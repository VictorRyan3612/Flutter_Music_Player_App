import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/data/playlist.dart';
import 'package:path_provider/path_provider.dart';

enum TableStatus {idle, loading, ready, error}

class MusicDataService{
  PlaylistService playlistsService = PlaylistService();
  ValueNotifier<List<String>> listFoldersPathsValueNotifier = ValueNotifier([]);

  ValueNotifier<List<String>> listPathsDeleted = ValueNotifier([]);
  ValueNotifier<List<String>> listMusicsError = ValueNotifier([]);
  ValueNotifier<Map<String,dynamic>> musicsValueNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'data': <Metadata>[]
  });


  var ordenableField = <String>[
    'trackName',
    'albumName',
    'albumArtistName'
  ];
  var ordenableFieldActual = '';
  ValueNotifier<Metadata> actualPlayingMusic = ValueNotifier(Metadata());
  List<Metadata> originalList = [];

  Set<String> setAlbumName = {};
  Set<String> setAlbumArtistName = {};
  Set<String> setGenders = {};


  ValueNotifier<Set<String>> actualTag = ValueNotifier({});

  bool shuffle = true;
  bool repeat = false;
  final player = AudioPlayer();
  bool firstPlay = true;
  bool addRepeat = false;
  bool isSorted = false;
  
  setConfigs({
    required List<String> listFoldersPaths, 
    required bool addRepeat, 
    required bool repeat,
    required bool shuffle})
    {
  
    addRepeat = addRepeat;
    repeat = repeat;
    shuffle = shuffle;
    // setFoldersPath(listFoldersPaths);
    playlistsService.loadPlaylists();

  }

  
  bool isMp3(String file){
    String format = file.split('.').last.toLowerCase();
    return format == 'mp3';
  }


  Future<void> copyFileWithData(String sourcePath, String destinationPath) async {
    musicsValueNotifier.value['status'] = TableStatus.loading;
    try {
      File sourceFile = File(sourcePath);
      File destinationFile = File(destinationPath);

      if (await sourceFile.exists()) {
        IOSink destinationSink = destinationFile.openWrite();
        await sourceFile.openRead().pipe(destinationSink);

        await destinationSink.flush();
        await destinationSink.close();

        // print('Arquivo copiado com sucesso de\n $sourcePath \npara\n $destinationPath');
        
      } else {
        print('Arquivo de origem não encontrado: $sourcePath');
      }
      musicsValueNotifier.value['status'] = TableStatus.ready;
    } catch (e) {
      print('Erro ao copiar arquivo: $e');
      musicsValueNotifier.value['status'] = TableStatus.error;
    }
  }


  String finalNamePath({required Directory directoryFolder, required String musicPath}){
    
    String nameMusic = musicPath!.split('\\').last;

    RegExp regex = RegExp(r'[^\x00-\x7F]');
    String nameFormated = nameMusic.replaceAll(regex, '');

    String pathFinal = '${directoryFolder.path}\\$nameFormated' ;

    return pathFinal;
  }


  Future<Directory> folderMusicsErrors() async{
    Directory directory = await getApplicationSupportDirectory();
    Directory directoryMusicsErrosFolder = Directory('${directory.path}\\musicsErrosCopies');
    directoryMusicsErrosFolder.createSync();
    return directoryMusicsErrosFolder;
  }

  Future<String> copyErrorMusic (String pathOrigin) async{
    Directory directory = await folderMusicsErrors();
    String pathFinal = finalNamePath(directoryFolder: directory, musicPath: pathOrigin);

    await copyFileWithData(pathOrigin, pathFinal);
    return pathFinal;
  }

  void addFolderPath(String folderPath) async {
    if (listFoldersPathsValueNotifier.value.contains(folderPath)) return;

    Directory directory = Directory(folderPath);
    List<File> listFiles = [];
    directory.listSync().forEach((entity) {
      if(isMp3(entity.path)){
        listFiles.add(File(entity.path));
      }
    });
    // loadMusicsDatas();
  }

  Future<void> removeFolderPath(String folderPath) async {
    musicsValueNotifier.value['status'] = TableStatus.loading;
    
    listFoldersPathsValueNotifier.value.remove(folderPath);
    listPathsDeleted.value.add(folderPath);
    
    for (var folderPath in listPathsDeleted.value){
      // listPaths.value.removeWhere((element) => element.contains(folderPath));
      List<Metadata> tempAux = musicDataService.musicsValueNotifier.value['data'];
      tempAux.removeWhere((element) => element.filePath!.contains(folderPath));
      musicDataService.musicsValueNotifier.value['data'] = tempAux;
      // musicsValueNotifier.value.removeWhere((key, value) => key[1].contains()
      // 
    // )}
    }
    musicsValueNotifier.value['status'] = TableStatus.ready;
    saveValueNotifier(musicsValueNotifier.value['data']);
  }

  void setsTags(Metadata metadata){
    setAlbumName.add(stringNonNull(metadata.albumName));
    setGenders.add(stringNonNull(metadata.genre));
    setAlbumArtistName.add(stringNonNull(metadata.albumArtistName));
  }

  Future<void> loadMusicsDatas() async{
    musicsValueNotifier.value['status'] = TableStatus.loading;
    var count = 0;
    for (var singlePath in []) {
      try {
        var metadata = await MetadataRetriever.fromFile(File(singlePath));
        if(metadata.bitrate == null){
          String musicCopiedpath = await copyErrorMusic(metadata.filePath!);
          listMusicsError.value.add(musicCopiedpath);
          
          metadata = await MetadataRetriever.fromFile(File(musicCopiedpath));
        }
        musicsValueNotifier.value['data'].add(metadata);
        setsTags(metadata);

      } catch (error) {
        print('Erro ao obter metadados do arquivo: $error');
        musicsValueNotifier.value['status'] = TableStatus.error;
      }
      count++;
      if(count == 50){
        count = 0;
        sortMusicByField();
        saveValueNotifier(musicsValueNotifier.value['data']);
      }
    }
    originalList = musicsValueNotifier.value['data'];
    sortMusicByField();
    saveValueNotifier(musicsValueNotifier.value['data']);
    // print(musicsValueNotifier.value['data']);
    musicsValueNotifier.value['status'] = TableStatus.ready;
    
  }


  void nextMusic(){
    int index = playlistsService.actualPlaylist.value['index'];
    int length = playlistsService.actualPlaylist.value['playlist'].length -1;

    if(musicDataService.player.playing){
      musicDataService.player.stop();
    }
    
    if(index < length){
      index += 1;
      actualPlayingMusic.value = playlistsService.actualPlaylist.value['playlist'][index];
      playlistsService.actualPlaylist.value['index'] = index;
    }
    else{
      int index;
      if (shuffle && !repeat) {
        int lenghtMusics= musicsValueNotifier.value['data'].length;
        index = Random().nextInt(lenghtMusics -1);
        addPlaylist(actualPlayingMusic.value);
      } 
      else if (repeat){
        index = musicsValueNotifier.value['data'].indexOf(actualPlayingMusic.value);
        if(addRepeat){
          addPlaylist(actualPlayingMusic.value);
        }
      }
      else {
        index = musicsValueNotifier.value['data'].indexOf(actualPlayingMusic.value) +1;
      }
      actualPlayingMusic.value = musicsValueNotifier.value['data'][index];
    }
    
    player.setAudioSource(AudioSource.file(actualPlayingMusic.value.filePath!));
    player.play();
  }
  void toggleRepeat(){
    repeat = !repeat;
  }
  void toggleShuffle(){
    shuffle = !shuffle;
  }

  void playMusicFromMetadata(Metadata metadata) async{
    musicDataService.actualPlayingMusic.value = metadata;
    
    if(musicDataService.player.playing){
      musicDataService.player.stop();
    }
    await musicDataService.player.setAudioSource(AudioSource.file(metadata.filePath as String));
    await musicDataService.player.play();
    addPlaylist(metadata);
  }
  
  void addPlaylist(Metadata metadata){
    playlistsService.actualPlaylist.value['playlist'].add(metadata);
    playlistsService.actualPlaylist.value['index'] +=1;
  }

  void addNextPlaylist(List<Metadata> listMetadata){
    int index = 1;
    listMetadata.forEach((element) {
      playlistsService.actualPlaylist.value['playlist'].insert(playlistsService.actualPlaylist.value['index']+index,element);
      index ++;
    });
    // actualPlaylist.value['playlist'].insert(actualPlaylist.value['index']+1,metadata);
  }

  void previousMusic(){
    if(playlistsService.actualPlaylist.value['index'] >=1){
      player.stop();
      playlistsService.actualPlaylist.value['index'] -=1;
      int index = playlistsService.actualPlaylist.value['index'];
      
      Metadata music = playlistsService.actualPlaylist.value['playlist'][index];
      actualPlayingMusic.value = music;
      player.setAudioSource(AudioSource.file(music.filePath!));
      player.play();
    }
  }
  String formatMilliseconds(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

  String stringNonNull(String? stringInitial){
    var string = '';
    if (stringInitial != null){
      string = stringInitial;
    }
    return string.trim();
  }


  void sortMusicByField([String field = 'trackName']){
    List<Metadata> listMusic = musicsValueNotifier.value['data'];

    if (field != ordenableFieldActual) {
      isSorted = false;
    }

    if (isSorted) {
      listMusic = List.from(listMusic.reversed);
    } 
    else {
      listMusic.sort((a, b) {
        String valueA = a.toJson()[field];
        String valueB = b.toJson()[field];
        return valueA.compareTo(valueB);
      });
      isSorted = true;
    }
    musicsValueNotifier.value['data'] = listMusic;
    saveValueNotifier(musicsValueNotifier.value['data']);
  }

  bool seachInFields (Metadata objetoInd, String filtrar){
    final bool =
      stringNonNull(objetoInd.trackName).toLowerCase().contains(filtrar.toLowerCase()) ||
      stringNonNull(objetoInd.albumArtistName).toLowerCase().contains(filtrar.toLowerCase()) ||
      stringNonNull(objetoInd.albumName).toLowerCase().contains(filtrar.toLowerCase()) ||
      stringNonNull(objetoInd.genre).toLowerCase().contains(filtrar.toLowerCase());
    return bool;
  }
  void filterCurrentState(String filtrar) {
    List<Metadata> objectsOriginals = originalList;
    if (objectsOriginals.isEmpty) return;

    List<Metadata> objectsFiltered = [];
    if (filtrar != '') {
      for (var objetoInd in objectsOriginals) {
        if (seachInFields(objetoInd, filtrar)) {
          objectsFiltered.add(objetoInd);
        }
      }
    } else {
      objectsFiltered = objectsOriginals;
    }
    

    saveValueNotifier(objectsFiltered);
  }
  void saveValueNotifier(List<Metadata> listMetadata) {
    var state = Map<String, dynamic>.from(musicsValueNotifier.value);
    state['data'] = listMetadata;
    musicsValueNotifier.value = state;
  }
}

MusicDataService musicDataService = MusicDataService();

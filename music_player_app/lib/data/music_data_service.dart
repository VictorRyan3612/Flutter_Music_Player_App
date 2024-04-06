import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

enum TableStatus {idle, loading, ready, error}

class MusicDataService{
  ValueNotifier<List<String>> listFoldersPathsValueNotifier = ValueNotifier([]);
  ValueNotifier<List<String>> listPaths = ValueNotifier([]);
  ValueNotifier<List<String>> listPathsDeleted = ValueNotifier([]);
  ValueNotifier<List<String>> listMusicsError = ValueNotifier([]);
  ValueNotifier<Map<String,dynamic>> musicsValueNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'objects': <Metadata>[]
  });

  ValueNotifier<Map<String,dynamic>> actualPlaylist = ValueNotifier({
    'index': -1,
    'playlist': <Metadata>[]
  });

  ValueNotifier<Metadata> actualPlayingMusic = ValueNotifier(Metadata());
  List<Metadata> originalList = [];

  Set<String> setAlbumName = {};
  Set<String> setAlbumArtistName = {};
  Set<String> setGenders = {};
  ValueNotifier<Set<String>> actualTag = ValueNotifier({});


  final player = AudioPlayer();
  
  void setFoldersPath(List<String> listFoldersPaths) async{
    listFoldersPathsValueNotifier.value = listFoldersPaths;
    foldersPathToFilesPath(listFoldersPathsValueNotifier.value);
    loadMusicsDatas();
  }

  bool isMp3(String file){
    String format = file.split('.').last.toLowerCase();
    return format == 'mp3';
  }

  void foldersPathToFilesPath(List<String> listPathFolders){
    for (var pathFolder in listPathFolders){
      Directory directory = Directory(pathFolder);
      directory.listSync().forEach((entity) {
        if(isMp3(entity.path)){
          listPaths.value.add(entity.path);
        }
      });
    }
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
    listFoldersPathsValueNotifier.value.add(folderPath);
    foldersPathToFilesPath([folderPath]);
    loadMusicsDatas();
  }
  
  Future<void> removeFolderPath(String folderPath) async {
    musicsValueNotifier.value['status'] = TableStatus.loading;
    
    listFoldersPathsValueNotifier.value.remove(folderPath);
    listPathsDeleted.value.add(folderPath);
    
    for (var folderPath in listPathsDeleted.value){
      listPaths.value.removeWhere((element) => element.contains(folderPath));
      List<Metadata> tempAux = musicDataService.musicsValueNotifier.value['objects'];
      tempAux.removeWhere((element) => element.filePath!.contains(folderPath));
      musicDataService.musicsValueNotifier.value['objects'] = tempAux;
      // musicsValueNotifier.value.removeWhere((key, value) => key[1].contains()
      // 
    // )}
    }
    musicsValueNotifier.value['status'] = TableStatus.ready;
    musicsValueNotifier.notifyListeners();
  }

  void setsTags(Metadata metadata){
    setAlbumName.add(stringNonNull(metadata.albumName));
    setGenders.add(stringNonNull(metadata.genre));
    setAlbumArtistName.add(stringNonNull(metadata.albumArtistName));
  }

  Future<void> loadMusicsDatas() async{
    musicsValueNotifier.value['status'] = TableStatus.loading;
    var count = 0;
    for (var singlePath in listPaths.value) {
      try {
        var metadata = await MetadataRetriever.fromFile(File(singlePath));
        if(metadata.bitrate == null){
          String musicCopiedpath = await copyErrorMusic(metadata.filePath!);
          listMusicsError.value.add(musicCopiedpath);
          
          metadata = await MetadataRetriever.fromFile(File(musicCopiedpath));
        }
        musicsValueNotifier.value['objects'].add(metadata);
        setsTags(metadata);

      } catch (error) {
        print('Erro ao obter metadados do arquivo: $error');
        musicsValueNotifier.value['status'] = TableStatus.error;
      }
      count++;
      if(count == 50){
        count = 0;
        musicsValueNotifier.notifyListeners();
      }
    }
    originalList = musicsValueNotifier.value['objects'];
    musicsValueNotifier.notifyListeners();
    // print(musicsValueNotifier.value['objects']);
    musicsValueNotifier.value['status'] = TableStatus.ready;
    
  }


  void nextMusic(){
    int index = actualPlaylist.value['index'];
    int length = actualPlaylist.value['playlist'].length -1;

    if(musicDataService.player.playing){
      musicDataService.player.stop();
    }
    
    if(index < length){
      index += 1;
      actualPlayingMusic.value = actualPlaylist.value['playlist'][index];
      actualPlaylist.value['index'] = index;
    }
    else{
      int lenghtMusics= musicsValueNotifier.value['objects'].length;
      int number = Random().nextInt(lenghtMusics -1);
      actualPlayingMusic.value = musicsValueNotifier.value['objects'][number];
      addPlaylist(actualPlayingMusic.value);

    }
    player.setAudioSource(AudioSource.file(actualPlayingMusic.value.filePath!));
    player.play();
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
    actualPlaylist.value['playlist'].add(metadata);
    actualPlaylist.value['index'] +=1;
  }

  void addNextPlaylist(Metadata metadata){
    actualPlaylist.value['playlist'].insert(actualPlaylist.value['index']+1,metadata);
  }

  void previousMusic(){
    if(actualPlaylist.value['index'] >=1){
      player.stop();
      actualPlaylist.value['index'] -=1;
      int index = actualPlaylist.value['index'];
      
      Metadata music = actualPlaylist.value['playlist'][index];
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

  void filterCurrentState(String filtrar) {
    List<Metadata> objectsOriginals = originalList;
    if (objectsOriginals.isEmpty) return;

    List<Metadata> objectsFiltered = [];
    if (filtrar != '') {
      for (var objetoInd in objectsOriginals) {
        if (
            stringNonNull(objetoInd.trackName).toLowerCase().contains(filtrar.toLowerCase()) ||
            stringNonNull(objetoInd.albumArtistName).toLowerCase().contains(filtrar.toLowerCase()) ||
            stringNonNull(objetoInd.albumName).toLowerCase().contains(filtrar.toLowerCase()) ||
            stringNonNull(objetoInd.genre).toLowerCase().contains(filtrar.toLowerCase()) 
          ) {
          objectsFiltered.add(objetoInd);
        }
      }
    } else {
      objectsFiltered = objectsOriginals;
    }
    

    issueFilteredState(objectsFiltered);
  }
  void issueFilteredState(List<Metadata> objectsFiltered) {
    var state = Map<String, dynamic>.from(musicsValueNotifier.value);
    state['objects'] = objectsFiltered;
    musicsValueNotifier.value = state;
  }
}

MusicDataService musicDataService = MusicDataService();

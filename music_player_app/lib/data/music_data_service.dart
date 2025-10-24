import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/data/files_service.dart';
import 'package:music_player_app/data/playlist.dart';


enum TableStatus {idle, loading, ready, error}

class MusicDataService{
  PlaylistService playlistsService = PlaylistService();
  ValueNotifier<List<String>> listFoldersPathsValueNotifier = ValueNotifier([]);

  ValueNotifier<List<String>> listPathsDeleted = ValueNotifier([]);
  ValueNotifier<List<String>> listMusicsError = ValueNotifier([]);
  ValueNotifier<Map<String,dynamic>> musicsValueNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'data':  <Map<String, dynamic>>[]
  });


  var ordenableField = <String>[
    'trackName',
    'albumName',
    'albumArtistName'
  ];
  var ordenableFieldActual = '';
  ValueNotifier<Map<String,dynamic>> actualPlayingMusic = ValueNotifier({});
  List<Map<String, dynamic>> originalList = [];

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
    required bool shuffle}) async
    {
  
    addRepeat = addRepeat;
    repeat = repeat;
    shuffle = shuffle;
    if (lastMusic != null) {
      var json = jsonDecode(lastMusic);
      actualPlayingMusic.value = json;
      await player.setAudioSource(AudioSource.file(json['filePath'] as String));
      // await player.pause();
      await player.stop();
      actualPlayingMusic.notifyListeners();
    }
    musicsValueNotifier.value['data'] = await filesService.loadJson();
    musicsValueNotifier.value['data'].forEach((element) => setsTags(element));
    originalList = musicsValueNotifier.value['data'];
    musicsValueNotifier.value['status'] = TableStatus.ready;
    saveValueNotifier(musicsValueNotifier.value['data']);

    playlistsService.loadPlaylists();
  }

  void addFolderPath(Directory directory) async{
    List<File> listMp3 = filesService.getListMp3Files(directory: directory);
    List<Map<String, dynamic>> musics = await filesService.loadMusicsDatas(listMp3);
    
    var musicsActual = musicsValueNotifier.value['data'];
    musicsActual.addAll(musics);

    filesService.saveJson(musicsActual);

    musicsValueNotifier.value['status'] = TableStatus.ready;

    saveValueNotifier(musicsActual);
  }

  void setsTags(Map<String,dynamic> metadata){
    setAlbumName.add(stringNonNull(metadata['albumName']));
    setGenders.add(stringNonNull(metadata['genre']));
    setAlbumArtistName.add(stringNonNull(metadata['albumArtistName']));
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
    
    player.setAudioSource(AudioSource.file(actualPlayingMusic.value['filePath']!));
    settingsService.lastMusic.value = jsonEncode(actualPlayingMusic.value);
    settingsService.saveSettings();
    player.play();
  }
  void toggleRepeat(){
    repeat = !repeat;
  }
  void toggleShuffle(){
    shuffle = !shuffle;
  }

  void playMusicFromMetadata(Map<String, dynamic> metadata) async{
    musicDataService.actualPlayingMusic.value = metadata;
    
    if(musicDataService.player.playing){
      musicDataService.player.stop();
    }
    await musicDataService.player.setAudioSource(AudioSource.file(metadata['filePath'] as String));
    await musicDataService.player.play();
    addPlaylist(metadata);
    settingsService.lastMusic.value = jsonEncode(actualPlayingMusic.value);
    settingsService.saveSettings();
  }
  
  void addPlaylist(Map<String,dynamic> metadata){
    playlistsService.actualPlaylist.value['playlist'].add(metadata);
    playlistsService.actualPlaylist.value['index'] +=1;
  }

  void addNextPlaylist(List<Map<String, dynamic>> listMetadata){
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
      
      Map<String,dynamic> music = playlistsService.actualPlaylist.value['playlist'][index];
      actualPlayingMusic.value = music;
      player.setAudioSource(AudioSource.file(music['filePath']!));
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
    List listMusic = musicsValueNotifier.value['data'];

    if (field != ordenableFieldActual) {
      isSorted = false;
    }

    if (isSorted) {
      listMusic = List.from(listMusic.reversed);
    } 
    else {
      listMusic.sort((a, b) {
        String valueA = a[field];
        String valueB = b[field];
        return valueA.compareTo(valueB);
      });
      isSorted = true;
    }
    musicsValueNotifier.value['data'] = listMusic;
    saveValueNotifier(musicsValueNotifier.value['data']);
  }

  bool seachInFields (Map<String, dynamic> objetoInd, String filtrar){
    final bool =
      stringNonNull(objetoInd['trackName']).toLowerCase().contains(filtrar.toLowerCase()) ||
      stringNonNull(objetoInd['albumArtistName']).toLowerCase().contains(filtrar.toLowerCase()) ||
      stringNonNull(objetoInd['albumName']).toLowerCase().contains(filtrar.toLowerCase()) ||
      stringNonNull(objetoInd['genre']).toLowerCase().contains(filtrar.toLowerCase());
    return bool;
  }
  void filterCurrentState(String filtrar) {
    List<Map<String, dynamic>> objectsOriginals = originalList;
    if (objectsOriginals.isEmpty) return;

    List<Map<String, dynamic>> objectsFiltered = [];
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
  void saveValueNotifier(List listMetadata) {
    var state = Map<String, dynamic>.from(musicsValueNotifier.value);
    state['data'] = listMetadata;
    musicsValueNotifier.value = state;
  }
}

MusicDataService musicDataService = MusicDataService();

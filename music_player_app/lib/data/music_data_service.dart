import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
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
    'data': []
  });


  var ordenableField = <String>[
    'trackName',
    'albumName',
    'albumArtistName'
  ];
  var ordenableFieldActual = '';
  ValueNotifier<Map<String,dynamic>> actualPlayingMusic = ValueNotifier({});
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

  void addFolderPath(String folderPath) async {
    
  }

  Future<void> removeFolderPath(String folderPath) async {
    
  }
  void setsTags(Metadata metadata){
    setAlbumName.add(stringNonNull(metadata.albumName));
    setGenders.add(stringNonNull(metadata.genre));
    setAlbumArtistName.add(stringNonNull(metadata.albumArtistName));
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
  }
  
  void addPlaylist(Map<String,dynamic> metadata){
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
  void saveValueNotifier(List listMetadata) {
    var state = Map<String, dynamic>.from(musicsValueNotifier.value);
    state['data'] = listMetadata;
    musicsValueNotifier.value = state;
  }
}

MusicDataService musicDataService = MusicDataService();

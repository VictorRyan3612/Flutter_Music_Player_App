import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:path_provider/path_provider.dart';

class PlaylistService{
  Set<String> setPlaylistsNames = {};
  ValueNotifier<List<Map<String,dynamic>>> playlists = ValueNotifier([
    {
      'name': '',
      'playlist': []
    }
  ]);
    ValueNotifier<Map<String,dynamic>> actualPlaylist = ValueNotifier({
    'index': -1,
    'playlist': <Metadata>[]
  });
  ValueNotifier<List<Metadata>> newplaylist = ValueNotifier([]);
  Future<bool> createPlaylist(String name, List<Metadata> list) async{
    Directory directoryApp = await getApplicationSupportDirectory();
    directoryApp = Directory('${directoryApp.path}/Playlists');
    directoryApp.createSync();

    File file = File('${directoryApp.path}/$name.dat');
    if (file.existsSync()){
      print("já existe Playlist com esse nome ");
      return true;
    }

    List<String> listPath =[];
    list.forEach((element) {
      listPath.add(element.filePath!);
    });
    Map<String,dynamic> mapPlaylist = {
      'name': name,
      'playlist': listPath
    };
    String jsonString = json.encode(mapPlaylist);
    
    file.writeAsStringSync(jsonString);
    playlists.value.add(mapPlaylist);
    setPlaylistsNames.add(mapPlaylist['name']);
    return false;
  }

  void loadPlaylists() async {
    Directory directoryApp = await getApplicationSupportDirectory();
    directoryApp = Directory('${directoryApp.path}/Playlists');
    directoryApp.createSync();

    directoryApp.listSync().forEach((element) { 
      File file = File(element.path);
      String content = file.readAsStringSync();
      var listMetada = json.decode(content);
      playlists.value.add({'name': listMetada['name'], 'playlist': listMetada['playlist']});
      setPlaylistsNames.add(listMetada['name']);

    });
  }

  void listplaylist(String name){
    List<Metadata> objectsOriginals = musicDataService.originalList;
    if (objectsOriginals.isEmpty) return;

    List<Metadata> objectsFiltered = [];
    List test =[];
    for (var playlist in playlists.value){
      if (playlist['name'] == name){
        test = playlist['playlist'];
      }
    }
    for (var objetoInd in objectsOriginals) {
      if (test.contains(objetoInd.filePath)) {
          objectsFiltered.add(objetoInd);
      }
    }

    musicDataService.saveValueNotifier(objectsFiltered);
  }
  void exportAllPlaylist(String finalFolderPath) async{
    Directory directoryApp = await getApplicationSupportDirectory();
    directoryApp = Directory('${directoryApp.path}/Playlists');
    directoryApp.createSync();

    Directory directoryFinal = Directory(finalFolderPath);


    directoryApp.listSync().forEach((element) {
      File file = File(element.path);
      musicDataService.copyFileWithData(file.path, musicDataService.finalNamePath(directoryFolder: directoryFinal, musicPath: file.path));
    });
    
    
  }
}
PlaylistService playlists = PlaylistService();
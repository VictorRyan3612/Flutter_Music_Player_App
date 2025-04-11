import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player_app/data/files_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:path_provider/path_provider.dart';

class PlaylistService{
  FilesService filesService = FilesService();
  Set<String> setPlaylistsNames = {};
  ValueNotifier<List<Map<String,dynamic>>> playlists = ValueNotifier([
    {
      'name': '',
      'playlist': []
    }
  ]);
    ValueNotifier<Map<String,dynamic>> actualPlaylist = ValueNotifier({
    'index': -1,
    'playlist': []
  });
  ValueNotifier<List<Metadata>> newplaylist = ValueNotifier([]);

  Future<bool> createPlaylist(String name, {List<Metadata>? listMetadata, List<String>? listPaths}) async{
    if (listMetadata == null && listPaths == null) {
    throw ArgumentError('Pelo menos um dos parâmetros opcionais (list ou listPaths) deve ser fornecido.');
  }

    Directory directoryApp = await getApplicationSupportDirectory();
    directoryApp = Directory('${directoryApp.path}/Playlists');
    directoryApp.createSync();

    File file = File('${directoryApp.path}/$name.dat');
    if (file.existsSync()){
      print("já existe Playlist com esse nome ");
      return true;
    }

    List<String> listPathFinal =  listPaths ?? [];
    // listMetadata ??= [];
    listPaths ??= [];
    if (listMetadata != null){
      listMetadata.forEach((element) {
        listPathFinal.add(element.filePath!);
      });

    }
    Map<String,dynamic> mapPlaylist = {
      'name': name,
      'playlist': listPathFinal
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
  void renamePlaylist(String oldName, String newName) {
    if (setPlaylistsNames.contains(oldName)) {
      setPlaylistsNames.remove(oldName);
      setPlaylistsNames.add(newName);
    }

    for (var playlist in playlists.value) {
      if (playlist['name'] == oldName) {
        playlist['name'] = newName;
        createPlaylist(newName, listPaths: List.from(playlist['playlist']));
        
      }
    }
    removePlaylist(oldName);
  }
  void removePlaylist(String name)async{
    Directory directoryApp = await getApplicationSupportDirectory();
    directoryApp = Directory('${directoryApp.path}/Playlists');
    directoryApp.createSync();
    File file = File('${directoryApp.path}/$name.dat');

    file.deleteSync();
    loadPlaylists();
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
      filesService.copyFileWithData(file.path, filesService.finalNamePath(directoryFolder: directoryFinal, musicPath: file.path));
    });
    
    
  }
  void exportAPlaylist(String finalFolderPath, String name) async{
    Directory directoryApp = await getApplicationSupportDirectory();
    directoryApp = Directory('${directoryApp.path}/Playlists');
    directoryApp.createSync();

    Directory directoryFinal = Directory(finalFolderPath);


    directoryApp.listSync().forEach((element) {
      var file = File(element.path);
      String stringName = '';
      stringName = element.path.split('\\').last;
      stringName = stringName.split('.').first;

      if (stringName == name){
      filesService.copyFileWithData(file.path, filesService.finalNamePath(directoryFolder: directoryFinal, musicPath: file.path));

      }

    });
    
    
  }
}
PlaylistService playlists = PlaylistService();
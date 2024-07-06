import 'dart:convert';
import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:path_provider/path_provider.dart';

class PlaylistService{
  
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
    musicDataService.playlists.value.add(mapPlaylist);
    musicDataService.setPlaylistsNames.add(mapPlaylist['name']);
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
      musicDataService.playlists.value.add({'name': listMetada['name'], 'playlist': listMetada['playlist']});
      musicDataService.setPlaylistsNames.add(listMetada['name']);

    });
  }

  void listplaylist(String name){
    List<Metadata> objectsOriginals = musicDataService.originalList;
    if (objectsOriginals.isEmpty) return;

    List<Metadata> objectsFiltered = [];
    List test =[];
    for (var playlist in musicDataService.playlists.value){
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
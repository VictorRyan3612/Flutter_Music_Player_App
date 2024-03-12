import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

enum TableStatus {idle, loading, ready, error}

class MusicDataService{
  ValueNotifier<List<String>> listFoldersPaths = ValueNotifier([]);
  ValueNotifier<List<String>> listPaths = ValueNotifier([]);
  ValueNotifier<Map<String,dynamic>> musicsValueNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'objects': []
  });

  Future<void> loadFolderPath() async {
    musicsValueNotifier.value['status'] = TableStatus.loading;

    try {
      Directory directory = Directory('C:/Off/As coisas de Victor/Musicas/Classics');
      directory.listSync().forEach((entity) {
        listPaths.value.add(entity.path);
      });

      musicsValueNotifier.value['status'] = TableStatus.ready;
    } catch (error) {
      print(error);
      musicsValueNotifier.value['status'] = TableStatus.error;
    }
  }
  isMp3(String file){
    String format = file.split('.').last.toLowerCase();
    return format == 'mp3';
  }
  foldersPathToFilesPath(List<String> listPathFolders){
    for (var pathFolder in listPathFolders){
      Directory directory = Directory(pathFolder);
      directory.listSync().forEach((entity) {

        if(isMp3(entity.path)){
          listPaths.value.add(entity.path);

        }
      });
    }
  }

  Future<void> loadMusicsDatas(List<String> listPathFolders) async{
    await foldersPathToFilesPath(listPathFolders);
    // await loadFolderPath();

    for (var singlePath in listPaths.value) {
      try {
        var metadata = await MetadataRetriever.fromFile(File(singlePath));

        if(metadata.trackDuration == null){
          print('Path: ${singlePath} trackDuration: ${metadata.trackDuration}\n');
        }
        
        musicsValueNotifier.value['objects'].add(metadata);
      } catch (error) {
        print('Erro ao obter metadados do arquivo: $error');
      }

    }
    musicsValueNotifier.value['status'] = TableStatus.ready;
    
  }

  String formatMilliseconds(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return '$minutesStr:$secondsStr';
  }

}

MusicDataService musicDataService = MusicDataService();

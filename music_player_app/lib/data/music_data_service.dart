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
  
  Future<void> loadMusicsDatas() async{
    await loadFolderPath();

    for (var singlePath in listPaths.value) {
      try {
        var metadata = await MetadataRetriever.fromFile(File(singlePath));
        musicsValueNotifier.value['objects'].add(metadata);
      } catch (error) {
        print('Erro ao obter metadados do arquivo: $error');
      }

    }
    // print(musicsValueNotifier.value['objects']);
    musicsValueNotifier.value['status'] = TableStatus.ready;
    
  }
}

MusicDataService musicDataService = MusicDataService();

import 'dart:io';

import 'package:flutter/material.dart';

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
}

MusicDataService musicDataService = MusicDataService();

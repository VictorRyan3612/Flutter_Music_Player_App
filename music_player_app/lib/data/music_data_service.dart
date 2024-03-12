import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';

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

  copyErrorMusic (String pathOrigin) async{
    Directory directory = await folderMusicsErrors();
    String pathFinal = finalNamePath(directoryFolder: directory, musicPath: pathOrigin);
  }


  Future<void> loadMusicsDatas(List<String> listPathFolders) async{
    await foldersPathToFilesPath(listPathFolders);
    // await loadFolderPath();

    for (var singlePath in listPaths.value) {
      try {
        var metadata = await MetadataRetriever.fromFile(File(singlePath));

        if(metadata.bitrate == null){
          String musicCopiedpath = copyErrorMusic(metadata.filePath!);

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

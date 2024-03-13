import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';

enum TableStatus {idle, loading, ready, error}

class MusicDataService{
  ValueNotifier<List<String>> listFoldersPathsValueNotifier = ValueNotifier([]);
  ValueNotifier<List<String>> listPaths = ValueNotifier([]);
  ValueNotifier<List<String>> listMusicsError = ValueNotifier([]);
  ValueNotifier<Map<String,dynamic>> musicsValueNotifier = ValueNotifier({
    'status': TableStatus.idle,
    'objects': []
  });

  setFoldersPath(List<String> listFoldersPaths) async{
    listFoldersPathsValueNotifier.value = listFoldersPaths;
    foldersPathToFilesPath(listFoldersPathsValueNotifier.value);
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

  addFolderPath(String folderPath) async {
    listFoldersPathsValueNotifier.value.add(folderPath);
    foldersPathToFilesPath([folderPath]);
  }
  
  removeFolderPath(String folderPath){
    listFoldersPathsValueNotifier.value.remove(folderPath);
  }

  Future<void> loadMusicsDatas() async{
    for (var singlePath in listPaths.value) {
      try {
        var metadata = await MetadataRetriever.fromFile(File(singlePath));

        if(metadata.bitrate == null){
          String musicCopiedpath = await copyErrorMusic(metadata.filePath!);
          listMusicsError.value.add(musicCopiedpath);
          
          var metadata2 = await MetadataRetriever.fromFile(File(musicCopiedpath));
          musicsValueNotifier.value['objects'].add(metadata2);
        }
        else{
          musicsValueNotifier.value['objects'].add(metadata);
        }
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

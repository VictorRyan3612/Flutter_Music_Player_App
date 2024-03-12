import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:path_provider/path_provider.dart';
enum TableStatus {idle, loading, ready, error}

class MusicDataService{
  ValueNotifier<List<String>> listFoldersPaths = ValueNotifier([]);
  ValueNotifier<List<String>> listPaths = ValueNotifier([]);
  ValueNotifier<List<String>> listMusicsError = ValueNotifier([]);
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


  Future<void> copyFileWithData(String sourcePath, String destinationPath) async {
  try {
    File sourceFile = File(sourcePath);
    File destinationFile = File(destinationPath);

    if (await sourceFile.exists()) {
      IOSink destinationSink = destinationFile.openWrite();
      await sourceFile.openRead().pipe(destinationSink);

      await destinationSink.flush();
      await destinationSink.close();

      print('Arquivo copiado com sucesso de\n $sourcePath \npara\n $destinationPath');
      
    } else {
      print('Arquivo de origem não encontrado: $sourcePath');
    }
  } catch (e) {
    print('Erro ao copiar arquivo: $e');
  }
}
  

  // String removeCharacters(String text){
  //   RegExp regex = RegExp(r'[^\x00-\x7F]');
  //   return text.replaceAll(regex, '');
  // }

  newName(Directory directory, String musicPath){
    var nomeMusic = musicPath!.split('\\').last;

    RegExp regex = RegExp(r'[^\x00-\x7F]');
    var nameFormated = nomeMusic.replaceAll(regex, '');


    String nameFinal = directory.path +'\\' + nameFormated ;
    return nameFinal;
  }

  Future<Directory> folderMusicsErrors() async{
    Directory directory = await getApplicationSupportDirectory();
    Directory directoryMusicsErrosFolder = Directory('${directory.path}\\musicsErrosCopies');
    directoryMusicsErrosFolder.createSync();
    return directoryMusicsErrosFolder;
  }

  Future<String> savecopy2(String path) async{
    Directory directory = await folderMusicsErrors();
    String nameFinal = newName(directory, path);
    
    await copyFileWithData(path, nameFinal);
    return nameFinal;
  }

  Future<void> loadMusicsDatas(List<String> listPathFolders) async{
    await foldersPathToFilesPath(listPathFolders);
    // await loadFolderPath();

    for (var singlePath in listPaths.value) {
      try {
        var metadata = await MetadataRetriever.fromFile(File(singlePath));

        if(metadata.bitrate == null){
          var namefinal = await savecopy2(metadata.filePath!);
          listMusicsError.value.add(namefinal);
          
          var metadata2 = await MetadataRetriever.fromFile(File(namefinal));
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

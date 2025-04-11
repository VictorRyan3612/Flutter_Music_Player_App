
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:path_provider/path_provider.dart';

class FilesService {

  void saveJson(List<Map<String, dynamic>> musics) async{
    Directory directory = await getApplicationSupportDirectory();
    print(directory);
    File file = File('${directory.path}\\allmusics.json');
    print(file.path);
    if(!file.existsSync()){
      file.createSync();

    }
    String jsonString = jsonEncode(musics);
    // file.writeAsStringSync(musicsValueNotifier.value['data'].toString());
    var teste = Uint8List.fromList(utf8.encode(jsonString));
    // file.writeAsSync(json.encode(musicsValueNotifier.value['data']));
    file.writeAsBytesSync(teste);
  }

  Future<List<Map<String,dynamic>>> loadJson() async{
    Directory directory = await getApplicationSupportDirectory();
    print(directory);
    File file = File('${directory.path}\\allmusics.json');

    if(!file.existsSync()){
      file.createSync();
    } 
    Uint8List bytes = await file.readAsBytes();
		String jsonString = utf8.decode(bytes);
		List<Map<String,dynamic>> jsonData = jsonDecode(jsonString);

    return jsonData;
    // musicsValueNotifier.value['data'] = 
  }

  bool isMp3(String file){
    String format = file.split('.').last.toLowerCase();
    return format == 'mp3';
  }

  String finalNamePath({required Directory directoryFolder, required String musicPath}){
    
    String nameMusic = musicPath!.split('\\').last;

    RegExp regex = RegExp(r'[^\x00-\x7F]');
    String nameFormated = nameMusic.replaceAll(regex, '');

    String pathFinal = '${directoryFolder.path}\\$nameFormated' ;

    return pathFinal;
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

        // print('Arquivo copiado com sucesso de\n $sourcePath \npara\n $destinationPath');
        
      } else {
        print('Arquivo de origem não encontrado: $sourcePath');
      }
    } catch (e) {
      print('Erro ao copiar arquivo: $e');
    }
  }
  Future<String> copyErrorMusic (String pathOrigin) async{
    Directory directory = await folderMusicsErrors();
    String pathFinal = finalNamePath(directoryFolder: directory, musicPath: pathOrigin);

    await copyFileWithData(pathOrigin, pathFinal);
    return pathFinal;
  }
  Future<Directory> folderMusicsErrors() async{
    Directory directory = await getApplicationSupportDirectory();
    Directory directoryMusicsErrosFolder = Directory('${directory.path}\\musicsErrosCopies');
    directoryMusicsErrosFolder.createSync();
    return directoryMusicsErrosFolder;
  }
  Future<File> saveAlbumArt({required Uint8List image, required name}) async{
    Directory directory = await getApplicationSupportDirectory();
    Directory directoryMusicsErrosFolder = Directory('${directory.path}\\AlbumsArt');
    print('${directoryMusicsErrosFolder.path}\\$name.jpg');
    // path.join()
    directoryMusicsErrosFolder.createSync();
    var fileImage = File('${directoryMusicsErrosFolder.path}\\$name.jpg');
    fileImage.writeAsBytesSync(image);
    return fileImage; 
  }

  Future<void> loadMusicsDatas(List<File> listFiles) async{
    List<Map<String, dynamic>> musicsDatas = [];
    List listMusicsError = [];
    var count = 0;
    for (var singlePath in listFiles) {
      try {
        var metadata = await MetadataRetriever.fromFile(singlePath);
        if(metadata.bitrate == null){
          String musicCopiedpath = await copyErrorMusic(metadata.filePath!);
          listMusicsError.add(musicCopiedpath);
          
          metadata = await MetadataRetriever.fromFile(File(musicCopiedpath));
        }
        // print(metadata);
        Map<String, dynamic> aux ={};
        aux.addAll(metadata.toJson());
        if (metadata.albumArt != null) {
          File file = await saveAlbumArt(image: metadata.albumArt!, name: metadata.albumName!);
          aux.addAll({'albumArtPath': file.path});
        }
        aux.remove('albumArt');
        musicsDatas.add(aux);
        // setsTags(metadata);

      } catch (error) {
        print('Erro ao obter metadados do arquivo: $error');
      }
      count++;
      if(count == 50){
        count = 0;
        // sortMusicByField();
        // saveValueNotifier(musicsDatas);
      }
    }
    saveJson(musicsDatas);
    // print(musicsDatas);
    // musicsValueNotifier.value['data'].addAll(musicsDatas);
    // originalList = musicsValueNotifier.value['data'];
    // sortMusicByField();
    // saveValueNotifier(musicsDatas);
    // print(musicsValueNotifier.value['data']);
    // musicsValueNotifier.value['status'] = TableStatus.ready;
    
  }

  void addFolderPath(String folderPath) async {
    if (settingsService.listFoldersPaths.value.contains(folderPath)) return;

    Directory directory = Directory(folderPath);
    List<File> listFiles = [];
    directory.listSync().forEach((entity) {
      if(isMp3(entity.path)){
        listFiles.add(File(entity.path));
      }
    });
    loadMusicsDatas(listFiles);
  }
  Future<void> removeFolderPath(String folderPath) async {
  }
  //   musicsValueNotifier.value['status'] = TableStatus.loading;
    
  //   listFoldersPathsValueNotifier.value.remove(folderPath);
  //   listPathsDeleted.value.add(folderPath);
    
  //   for (var folderPath in listPathsDeleted.value){
  //     // listPaths.value.removeWhere((element) => element.contains(folderPath));
  //     List<Metadata> tempAux = musicDataService.musicsValueNotifier.value['data'];
  //     tempAux.removeWhere((element) => element.filePath!.contains(folderPath));
  //     musicDataService.musicsValueNotifier.value['data'] = tempAux;
  //     // musicsValueNotifier.value.removeWhere((key, value) => key[1].contains()
  //     // 
  //   // )}
  //   }
  //   musicsValueNotifier.value['status'] = TableStatus.ready;
  //   saveValueNotifier(musicsValueNotifier.value['data']);
  // }
}
FilesService filesService = FilesService();

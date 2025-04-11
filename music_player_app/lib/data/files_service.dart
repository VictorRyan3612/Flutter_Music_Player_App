
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class FilesService {

  void saveJson(Map<String, dynamic> musics) async{
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
    file.writeAsBytesSync(teste, mode: FileMode.append);
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
}

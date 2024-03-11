import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/layout/layout.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends HookWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      // theme: finalTheme,
      debugShowCheckedModeBanner: false,
      

      home: FutureBuilder(
        future: musicDataService.loadMusicsDatas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            print(musicDataService.musicsValueNotifier.value['objects']);
            return LayoutDecider();
            
          }
        },
        
      ),

      // initialRoute: '/',
      // routes: {
      //   '/': (context) => LayoutDecider(),
      // }
    );
  }
}
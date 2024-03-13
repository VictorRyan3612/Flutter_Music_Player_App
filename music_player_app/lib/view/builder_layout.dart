import 'package:flutter/material.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/layout/layout.dart';


class BuilderLayout extends StatelessWidget {
  const BuilderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> foldersPaths = [
    'C:/Off/As coisas de Victor/Musicas/7MZ Duelo de Titans',
    // 'C:/Off/As coisas de Victor/Musicas/7MZ Raps',
    // 'C:/Off/As coisas de Victor/Musicas/A-B',
    // 'C:/Off/As coisas de Victor/Musicas/C-E',
    // 'C:/Off/As coisas de Victor/Musicas/Classics',
    // 'C:/Off/As coisas de Victor/Musicas/Covers',
    // 'C:/Off/As coisas de Victor/Musicas/F',
    // 'C:/Off/As coisas de Victor/Musicas/H-I',
    // 'C:/Off/As coisas de Victor/Musicas/Is',
    // 'C:/Off/As coisas de Victor/Musicas/K-M',
    // 'C:/Off/As coisas de Victor/Musicas/M',
    // 'C:/Off/As coisas de Victor/Musicas/Midnight Club 3',
    // 'C:/Off/As coisas de Victor/Musicas/Montage Rock',
    // 'C:/Off/As coisas de Victor/Musicas/N',
    // 'C:/Off/As coisas de Victor/Musicas/O',
    // 'C:/Off/As coisas de Victor/Musicas/Playlists',
    // 'C:/Off/As coisas de Victor/Musicas/P-R',
    // 'C:/Off/As coisas de Victor/Musicas/Reverse Rock',
    // 'C:/Off/As coisas de Victor/Musicas/S',
    // 'C:/Off/As coisas de Victor/Musicas/Shingeki no Kyojin',
    // 'C:/Off/As coisas de Victor/Musicas/Sundry',
    // 'C:/Off/As coisas de Victor/Musicas/Tauz Games',
    // 'C:/Off/As coisas de Victor/Musicas/Tauz Singles',
    // 'C:/Off/As coisas de Victor/Musicas/T-Z'
  ];
  var a = ['C:/Off/As coisas de Victor/Musicas/a'];
    return ValueListenableBuilder(
      valueListenable: settingsService.listFoldersPaths,
      builder: (context, value, child) {
        return FutureBuilder(
        // future: musicDataService.loadMusicsDatas(foldersPaths),
        future: musicDataService.loadMusicsDatas(settingsService.listFoldersPaths.value),
        // future: musicDataService.loadMusicsDatas(a),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            return LayoutDecider();
          }
        });
      },
      
    );
  }
}

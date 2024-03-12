import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/layout/layout.dart';


class BuilderLayout extends StatelessWidget {
  const BuilderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> foldersPaths = [
    'C:/Off/As coisas de Victor/Musicas/7MZ Duelo de Titans',
    'C:/Off/As coisas de Victor/Musicas/7MZ Raps',
    'C:/Off/As coisas de Victor/Musicas/C-E',
    'C:/Off/As coisas de Victor/Musicas/Classics',
    'C:/Off/As coisas de Victor/Musicas/Covers',
    'C:/Off/As coisas de Victor/Musicas/Is',
    'C:/Off/As coisas de Victor/Musicas/Midnight Club 3',
    'C:/Off/As coisas de Victor/Musicas/Montage Rock',
    'C:/Off/As coisas de Victor/Musicas/Playlists',
    'C:/Off/As coisas de Victor/Musicas/Reverse Rock',
    'C:/Off/As coisas de Victor/Musicas/Rock',
    'C:/Off/As coisas de Victor/Musicas/Shingeki no Kyojin',
    'C:/Off/As coisas de Victor/Musicas/Sundry',
    'C:/Off/As coisas de Victor/Musicas/Tauz Games',
    'C:/Off/As coisas de Victor/Musicas/Tauz Singles',
    'C:/Off/As coisas de Victor/Musicas/T-Z'
  ];

    return FutureBuilder(
      future: musicDataService.loadMusicsDatas(foldersPaths),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          return LayoutDecider();
        }
      }
    );
  }
}

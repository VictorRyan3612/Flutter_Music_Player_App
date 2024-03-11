import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/layout/layout.dart';


class BuilderLayout extends StatelessWidget {
  const BuilderLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: musicDataService.loadMusicsDatas(),
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

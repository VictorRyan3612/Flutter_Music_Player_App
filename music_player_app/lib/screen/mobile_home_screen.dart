import 'package:flutter/material.dart';

import 'package:music_player_app/view/list_music.dart';
import 'package:music_player_app/widgets/sheet_tile.dart';


class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music"),
        leading: Icon(Icons.menu),
      ),
      body: Column(
        children: [
          Expanded(child: ListMusics()),
      
          SheetTile()
        ],
      )
    );
  }
}

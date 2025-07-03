import 'package:flutter/material.dart';

import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/screen/music_playing_screen.dart';
import 'package:music_player_app/widgets/play_button.dart';

class SheetTile extends StatelessWidget {
  const SheetTile({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: musicDataService.actualPlayingMusic,
      builder: (context, value, child) {
        if (value['filePath'] == null){
          return Container();
        }
        return ListTile(
          
          leading: PlayButton(),
          
          title: Text("${value['trackName']}", style: TextStyle(fontSize: 20),),
          subtitle: Text("${value['albumArtistName']} - ${value['albumName']}", style: TextStyle(fontSize: 15)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MusicPlayingScreen()),
            );
          },
        );
      }
    );
  }
}

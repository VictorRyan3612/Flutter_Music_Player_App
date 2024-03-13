import 'package:flutter/material.dart';
import 'package:music_player_app/view/list_music.dart';


class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(context, '/configs');
          },),
      ),
      body: ListMusics()
    );
  }
}

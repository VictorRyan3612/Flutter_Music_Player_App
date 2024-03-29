import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/view/list_music.dart';
import 'package:music_player_app/widgets/lateral_bar.dart';

import 'package:music_player_app/widgets/sheet_tile.dart';


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
      body: Row(
        children: [
          ExtensibleLateralBar(),
          Expanded(
            flex: 9,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    musicDataService.filterCurrentState(value);
                  },
                  decoration: InputDecoration(
                    hintText: "filtrar",
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: musicDataService.musicsValueNotifier,
                    builder: (context, value, child) {
                      return ListMusics();
                    }
                  )
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
            
                  SheetTile()
            
                  ] )
              ],
            ),
          ),
        ],
      )
    );
  }
}

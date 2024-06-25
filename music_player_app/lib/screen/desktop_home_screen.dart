import 'package:flutter/material.dart';

import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/view/list_music.dart';
import 'package:music_player_app/view/list_tag.dart';
import 'package:music_player_app/widgets/app_bar_buttons.dart';
import 'package:music_player_app/widgets/lateral_bar.dart';
import 'package:music_player_app/widgets/sheet_tile.dart';


class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          LateralBar(),
          Expanded(
            flex: 12,
            child: Column(
              children: [
                AppBarButtons(),
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
                    valueListenable: settingsService.listingTags,
                    builder: (context, value, child) {
                      if(!value){ 
                        return ValueListenableBuilder(
                          valueListenable: musicDataService.musicsValueNotifier,
                          builder: (context, value, child) {
                            return ListMusics();
                          }
                        );
                      }
                      else{
                        return ListTag();
                      }
                    }
                  )
                ),
                SheetTile()
              ],
            ),
          ),
        ],
      )
    );
  }
}

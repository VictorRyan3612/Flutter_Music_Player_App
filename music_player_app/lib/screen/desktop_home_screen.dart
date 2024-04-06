import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/view/list_music.dart';
import 'package:music_player_app/view/list_tag.dart';
import 'package:music_player_app/widgets/dropdown.dart';
import 'package:music_player_app/widgets/lateral_bar.dart';

import 'package:music_player_app/widgets/sheet_tile.dart';


class DesktopHomeScreen extends StatelessWidget {
  const DesktopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          ExtensibleLateralBar(
            items: [
              ExtensibleLateralBarItem(
                icon: Icon(Icons.home), 
                title: Text("Home"), 
                onTap: (){
                  settingsService.listingTags.value = false;
                  musicDataService.musicsValueNotifier.value['objects'] = musicDataService.originalList;
                  settingsService.tag.value = '';
                }
              ),
              ExtensibleLateralBarItem(
                icon: Icon(Icons.people), 
                title: Text("Artistas"), 
                onTap: (){
                  settingsService.listingTags.value = true;
                  musicDataService.actualTag.value = musicDataService.setAlbumArtistName;
                }
              ),
              ExtensibleLateralBarItem(
                icon: Icon(Icons.library_music), 
                title: Text("Albums"), 
                onTap: (){
                  settingsService.listingTags.value = true;
                  musicDataService.actualTag.value = musicDataService.setAlbumName;
                }
              ),
              ExtensibleLateralBarItem(
                icon: Icon(Icons.music_note), 
                title: Text("Generos"), 
                onTap: (){
                  settingsService.listingTags.value = true;
                  musicDataService.actualTag.value = musicDataService.setGenders;
                }
              ),
            ],
            trailingItems: [
              ExtensibleLateralBarItem(
                  icon: Icon(Icons.settings),
                  title: Text("Configuracoes"),
                  onTap: () {
                    Navigator.pushNamed(context, '/configs');
                  },
                )

            ],
            
          ),
          Expanded(
            flex: 12,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownWidget()
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          musicDataService.filterCurrentState(value);
                        },
                        decoration: InputDecoration(
                          hintText: "filtrar",
                        ),
                      ),
                    )

                  ],
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

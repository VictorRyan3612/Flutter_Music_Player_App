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
                Row(
                  children: [
                    ValueListenableBuilder (
                      valueListenable: settingsService.isSelecting,
                      builder: (context, value, child) {
                        if (value) {
                          return IconButton(
                            tooltip: 'Criar nova playlist',
                            onPressed: () {
                              final controller = TextEditingController();
                              showDialog(
                                context: context, builder: (context) {
                                  return AlertDialog(
                                    title: Text('Titulo'),
                                    actions: [
                                      TextButton(
                                        onPressed:(){
                                          Navigator.of(context).pop();
                                        }, 
                                        child: Text('Cancelar')
                                      ),
                                      TextButton(
                                        onPressed:(){
                                          musicDataService.createPlaylist(controller.text, musicDataService.newplaylist.value);
                                          musicDataService.newplaylist.value = [];
                                          Navigator.of(context).pop();
                                        }, 
                                        child: Text('Confirmar')
                                      )
                                    ],
                                    content: Form(child: TextField(
                                      controller: controller,
                                      autofocus: true,
                                    )),
                                  );
                                },);
                              // musicDataService.newplaylist.value.forEach((element) {print(element.trackName);});
                            }, 
                            icon: Icon(Icons.playlist_add)
                          );
                        } else {
                          return Container();
                        }
                      }
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

import 'package:flutter/material.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/view/list_music.dart';


class ListTag extends StatelessWidget {


  const ListTag({super.key});

  @override
  Widget build(BuildContext context) {
    showMenu(){
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    title: Text('Reproduzir'),
                    leading: Icon(Icons.play_arrow),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  settingsService.listingPlaylist ? ListTile(
                    title: Text('Renomear'),
                    leading: Icon(Icons.drive_file_rename_outline_sharp),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ) : Container()
                  
                ],
              ),
            )
          );
        },
      );
    }
    
    return ValueListenableBuilder(
      valueListenable: settingsService.tag, 
      builder: (context, value1, child) {
        if(value1 != ''){
          return ListMusics();
        }else {
          return ValueListenableBuilder(
            valueListenable: musicDataService.actualTag, 
            builder: (context, value, child) {
              List<String> listTag = value.toList();
              listTag.sort();
              return ListView.builder(
                itemCount: listTag.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: ListTile(
                      title: Text(listTag[index]),
                    ),
                    onTap: () {
                      if (settingsService.listingPlaylist) {
                        settingsService.tag.value = listTag[index];
                        musicDataService.playlistsService.listplaylist(listTag[index]);
                      } else {
                        musicDataService.filterCurrentState(listTag[index]);
                        settingsService.tag.value = listTag[index];
                        
                      }
                    },
                    onLongPress: () {
                      showMenu();
                    },
                    onSecondaryTapDown: (details) {
                      showMenu();
                    },
                  );
                },
              );
            }
          );
        }
        }
      
    );
  }
}

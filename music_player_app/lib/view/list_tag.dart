import 'package:flutter/material.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/view/list_music.dart';


class ListTag extends StatelessWidget {


  const ListTag({super.key});

  @override
  Widget build(BuildContext context) {

    
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
                  return ListTile(
                    title: Text(listTag[index]),
                    onTap: () {
                      musicDataService.filterCurrentState(listTag[index]);
                      settingsService.tag.value = listTag[index];
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

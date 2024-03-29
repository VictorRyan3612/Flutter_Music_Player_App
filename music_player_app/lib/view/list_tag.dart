import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';


class ListTag extends StatelessWidget {


  const ListTag({super.key});

  @override
  Widget build(BuildContext context) {

    
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
            );
          },
        );
      }
    );
  }
}

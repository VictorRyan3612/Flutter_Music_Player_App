import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';

class ListMusics extends StatelessWidget {
  const ListMusics({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: musicDataService.musicsValueNotifier,
          builder: (context, value, child) {
            return ListView.builder(
              
              itemCount: value['objects'].length,
              itemBuilder: (context, index) {
                
                return ListTile(
                  title: Text("${value['objects'][index].trackName}", style: TextStyle(fontSize: 20),),
                  subtitle: Text("${value['objects'][index].albumArtistName} - ${value['objects'][index].albumName}", style: TextStyle(fontSize: 15)),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Builder(
                        builder: (context) {
                          if (value['objects'][index].trackDuration == null){
                            return Text('00:00',style: TextStyle(fontSize: 15));
                          }
                          return Text(
                            "${musicDataService.formatMilliseconds(value['objects'][index].trackDuration)}",
                            style: TextStyle(fontSize: 15),
                          );
                        },
                        
                      ),
                    ],
                  ),
                  leading: Builder(
                    builder: (context) {
                      try {
                        return Image.memory(value['objects'][index].albumArt);
                      } catch (e) {
                        return Icon(Icons.music_note);
                      }
                    },
                  ),

                );
              },
            );
          },
        ),
      );
  }
}
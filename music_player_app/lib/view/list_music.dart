import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/widgets/music_tile.dart';

class ListMusics extends StatelessWidget {
  const ListMusics({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder(
        valueListenable: musicDataService.musicsValueNotifier,
        builder: (context, value, child) {
          switch (value['status']) {
            case TableStatus.loading:
              return Center(child: CircularProgressIndicator());
            case TableStatus.error:
            return Center(
              child: Text("Error"),
            );
            case TableStatus.ready:
              return ListView.builder(
                itemCount:value['objects'].length,
                itemBuilder: (context, index) {
                  return MusicTile(music: value['objects'][index],);
                }
              );
          } return Container();
        }
      )
    );
  }
}


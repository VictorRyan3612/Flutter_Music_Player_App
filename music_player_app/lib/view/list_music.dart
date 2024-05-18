import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/widgets/music_tile.dart';

class ListMusics extends StatelessWidget {
  const ListMusics({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedColor = Colors.blue;

    void showContextMenu(BuildContext context, Metadata music, Offset position) {
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(position.dx, position.dy, position.dx, position.dy),
        elevation: 8.0,
        items: <PopupMenuEntry>[
          PopupMenuItem(
            value: 0,
            child: ListTile(
              leading: Icon(Icons.skip_next_sharp),
              title: Text('Reproduzir em seguida'),
            ),
            onTap: () {
              musicDataService.addNextPlaylist(music);
            },
          ),
        ],
      );
    }

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
                itemCount:value['data'].length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onSecondaryTapDown: (details) {
                      showContextMenu(context, value['data'][index], details.globalPosition);
                    },
                    onTap: () async{
                      musicDataService.playMusicFromMetadata(value['data'][index]);
                    },

                    child: ValueListenableBuilder(
                      valueListenable: musicDataService.actualPlayingMusic,
                      builder: (context, actualPlaying, child) {
                        final music = value['data'][index];
                        final isActualPlaying = musicDataService.actualPlayingMusic.value == music;
                        return MusicTile(
                          music: music,
                          color: isActualPlaying  ? selectedColor : null,);
                      }
                    ),
                    
                  );
                }
              );
          } return Container();
        }
      )
    );
  }
}

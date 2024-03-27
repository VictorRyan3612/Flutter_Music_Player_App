import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/widgets/music_tile.dart';

class ListMusics extends StatelessWidget {
  const ListMusics({super.key});

  @override
  Widget build(BuildContext context) {
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
                itemCount:value['objects'].length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onSecondaryTapDown: (details) {
                      showContextMenu(context, value['objects'][index], details.globalPosition);
                    },
                    child: MusicTile(music: value['objects'][index]),
                    onTap: () async{
                      musicDataService.playMusicFromMetadata(value['objects'][index]);
                    },
                  );
                }
              );
          } return Container();
        }
      )
    );
  }
}

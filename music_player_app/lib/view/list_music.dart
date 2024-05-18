import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

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
              return ListViewMusic(listMusics: value['data'],);
          } return Container();
        }
      )
    );
  }
}

class ListViewMusic extends HookWidget {
  final List<Metadata> listMusics;


  const ListViewMusic({
    super.key,
    required this.listMusics,
  });


  @override
  Widget build(BuildContext context) {
    final selectedColor = Colors.blue;
    final listSelected = useState([]);
    final isSelecting = useState(false);
    final selectedItem = useState<int>(-1);
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
    return ListView.builder(
      itemCount:listMusics.length,
      itemBuilder: (context, index) {
        return MouseRegion(
          onEnter: (_) {
            selectedItem.value = index;
          },
          onExit: (_) {
            selectedItem.value = -1;
          },
          child: Container(
            color: listSelected.value.contains(listMusics[index]) ? selectedColor : null,
            child: InkWell(
              onLongPress: () {
                isSelecting.value =true;
                listSelected.value.add(listMusics[index]);
              },
              onSecondaryTapDown: (details) {
                showContextMenu(context, listMusics[index], details.globalPosition);
              },
              onTap: () async{
                if (isSelecting.value) {
                  listSelected.value.add(listMusics[index]);
                } else {
                  musicDataService.playMusicFromMetadata(listMusics[index]);
                  
                }
              },
                
              child: ValueListenableBuilder(
                valueListenable: musicDataService.actualPlayingMusic,
                builder: (context, actualPlaying, child) {
                  final music = listMusics[index];
                  final isActualPlaying = musicDataService.actualPlayingMusic.value == music;
                  return MusicTile(
                    music: music,
                    color: isActualPlaying  ? selectedColor : null,);
                }
              ),
              
            ),
          ),
        );
      }
    );
  }
}

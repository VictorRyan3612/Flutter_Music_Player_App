import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/widgets/music_tile.dart';

import 'package:flutter_vicr_widgets/flutter_vicr_widgets.dart';

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
            return ValueListenableBuilder(
              valueListenable: settingsService.isTable,
              builder: (context, valueIsTable, child) {
                if (valueIsTable) {
                  return SingleChildScrollView(
                  child: VicrDataTableWidget(
                    onTapRow: (item) {
                      musicDataService.playMusicFromMetadata(item);
                    },
                    accessCallback: (obj, property) {
                      return obj.toJson()[property];
                    },
                    columns: musicDataService.ordenableField,
                    objects: musicDataService.musicsValueNotifier.value['data'],
                    sortCallback: (value){
                      musicDataService.sortMusicByField(value);
                    },
                    // columnsNames: [],
                  ),
                );
                } else {
                  return ListViewMusic(
                    listMusics: value['data'],
                    isSelecting: settingsService.isSelecting,
                    playlist: musicDataService.playlistsService.newplaylist,
                  );
                }
                
              }
            );
          } return Container();
        }
      )
    );
  }
}

class ListViewMusic extends HookWidget {
  final List listMusics;
  final ValueNotifier<bool>? isSelecting;
  final ValueNotifier<List<Map<String, dynamic>>>? playlist;
  const ListViewMusic({
    super.key,
    required this.listMusics,
    this.isSelecting,
    this.playlist
  });


  @override
  Widget build(BuildContext context) {
    final selectedColor = Colors.blue;
    final listSelected = playlist ?? useState([]);
    final isSelectingState = isSelecting ?? useState(false);
    final selectedItem = useState<int>(-1);
    void showContextMenu(BuildContext context, Map<String, dynamic> music, Offset position) {
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
              musicDataService.addNextPlaylist([music]);
            },
          ),
        ],
      );
    }
    void modifyList(Map<String, dynamic> metadata, Function(List<Map<String, dynamic>> list, Map<String, dynamic> metadata) function){
      final lista = List<Map<String, dynamic>>.from(listSelected.value);
      function(lista, metadata);
      listSelected.value = lista;
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
          child: ValueListenableBuilder(
            valueListenable: listSelected,
            builder: (context, listSelectedValue, child) {
              return Container(
                color: listSelectedValue.contains(listMusics[index]) ? selectedColor : null,
                child: InkWell(
                  onLongPress: () {
                    isSelectingState.value =true;
                    modifyList(listMusics[index], (list, metadata) => list.add(metadata));
                  },
                  onSecondaryTapDown: (details) {
                    showContextMenu(context, listMusics[index], details.globalPosition);
                  },
                  onTap: () async{
                    if (isSelectingState.value) {
                      modifyList(listMusics[index], (list, metadata) => list.add(metadata));
                      if (listSelected.value.isEmpty) {
                        isSelectingState.value = false;
                      }
                    } else {
                      musicDataService.playMusicFromMetadata(listMusics[index]);
                      
                    }
                  },
                    
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25,
                        child: selectedItem.value == index ? Checkbox(
                        activeColor: listSelectedValue.contains(listMusics[index]) ? Colors.red : null,
                        value: listSelectedValue.contains(listMusics[index]), 
                        onChanged: (newValue) {
                          isSelectingState.value = true;
                          if (newValue!) {
                            modifyList(listMusics[index], (list, metadata) => list.add(metadata));
                          } else {
                            modifyList(listMusics[index], (list, metadata) => list.remove(metadata));
                          }
                          if (listSelected.value.isEmpty) {
                            isSelectingState.value = false;
                          }
                          selectedItem.value = index;
                        },
                      ) : Container(),
                      ),
                      Expanded(
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
                    ],
                  ),
                  
                ),
              );
            }
          ),
        );
      }
    );
  }
}

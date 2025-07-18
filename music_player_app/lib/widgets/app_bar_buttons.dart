import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';

final nameNewPlaylistController = TextEditingController();

class AppBarButtons extends StatelessWidget implements PreferredSizeWidget{
  const AppBarButtons({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black26,
      title: NumberMusics(),
      actions: [
        IconButton(
          tooltip: 'Selecionar tudo',
          icon: Icon(Icons.select_all),
          onPressed: () {
            final allMusics = musicDataService.musicsValueNotifier.value['data'];
            final selected = musicDataService.playlistsService.newplaylist;

            if (settingsService.isSelecting.value && selected.value.length == allMusics.length) {
              selected.value = [];
              settingsService.isSelecting.value = false;
            } else {
              settingsService.isSelecting.value = true;
              selected.value = List<Map<String, dynamic>>.from(allMusics);
            }
          },
        ),

        ValueListenableBuilder(
          valueListenable: settingsService.isSelecting, 
          builder: (context, value, child) {
            if (value) {
              return Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.all_out),
                    onPressed: () {
                      final allMusics = musicDataService.musicsValueNotifier.value['data'];
                      final selected = musicDataService.playlistsService.newplaylist;

                      final newList = <Map<String, dynamic>>[];

                      for (var music in allMusics) {
                        if (!selected.value.contains(music)) {
                          newList.add(music);
                        }
                      }

                      selected.value = newList;

                      if (selected.value.isEmpty) {
                        settingsService.isSelecting.value = false;
                      } else {
                        settingsService.isSelecting.value = true;
                      }
                    },
                  ),

                  IconButton(
                    tooltip: 'Ações',
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showDialog(
                        context: context, builder: (context) {
                          return AlertDialog(
                            content: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text('Adicionar a playlist'),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      showDialog(context: context, builder: (context) {
                                        return NewPlaylistAlertDialog();
                                      });
                                    },
                                  ),
                                  ListTile(
                                    title: Text('Reproduzir em seguida'),
                                    onTap: () {
                                      // musicDataService.addNextPlaylist(musicDataService.playlistsService.newplaylist.value);
                                      Navigator.of(context).pop();
                                    },
                                  )
                                  
                                ],
                              ),
                            )
                          );
                        }
                      );
                    }
                  ),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
        IconButton(
          tooltip: 'Ordenar',
          icon: Icon(Icons.sort_by_alpha_outlined),  
          onPressed: () {
            showDialog(context: context, 
              builder: (context) {
                return AlertDialog(
                  content: ListViewRadioSort(),
                  actions: [
                    TextButton(
                    onPressed:(){
                      Navigator.of(context).pop();
                    }, 
                    child: Text('Cancelar')
                  ),
                  TextButton(
                    onPressed:(){
                      musicDataService.sortMusicByField(musicDataService.ordenableFieldActual);
                    }, 
                    child: Text('Inverter')
                  )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class ListViewRadioSort extends HookWidget {
  const ListViewRadioSort({super.key});

  @override
  Widget build(BuildContext context) {
    var currentOption = useState(musicDataService.ordenableFieldActual);

    return SizedBox(
      width: double.minPositive, 
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: musicDataService.ordenableField.length,
        itemBuilder: (context, index) {
          return RadioListTile(
            title: Text(musicDataService.ordenableField[index]),
            value: musicDataService.ordenableField[index],
            groupValue: currentOption.value,
            onChanged: (value) {
              currentOption.value = value!;
              musicDataService.sortMusicByField(value);
              musicDataService.ordenableFieldActual = currentOption.value;
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}

class NumberMusics extends StatelessWidget {
  const NumberMusics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: musicDataService.musicsValueNotifier,
      builder: (context, musicsValueNotifier, child) {
        return ValueListenableBuilder(
          valueListenable: musicDataService.playlistsService.newplaylist,
          builder: (context, newplaylist, child) {
            if (newplaylist.isEmpty){
              return Text('${musicsValueNotifier['data'].length}');
            }
            else{
              return Text('${newplaylist.length}/${musicsValueNotifier['data'].length}');

            }
          },
        );
      }
    );
  }
}


class NewPlaylistAlertDialog extends StatelessWidget {
  const NewPlaylistAlertDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
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
              onPressed:() async{
                var error = await musicDataService.playlistsService.createPlaylist(
                  nameNewPlaylistController.text, 
                  listMetadata: musicDataService.playlistsService.newplaylist.value
                );
                if (error) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Já há uma playlist com esse nome'),
                        actions: [
                          TextButton(
                          onPressed:(){
                            Navigator.of(context).pop();
                            return;
                          }, 
                          child: Text('Cancelar')
                        ),
                        TextButton(
                          onPressed:(){
                            Navigator.of(context).pop();
                            showDialog(context: context, builder: (context) {
                              return NewPlaylistAlertDialog();
                            });
                          }, 
                          child: Text('Mudar o nome')
                        )
                        ],
                      );
                    },
                  );
                } else {
                  musicDataService.playlistsService.newplaylist.value = [];
                Navigator.of(context).pop();
                }
              }, 
              child: Text('Confirmar')
            )
          ],
          content: Form(child: TextField(
            controller: nameNewPlaylistController,
            autofocus: true,
          )),
        );
      }
    );
  }
}
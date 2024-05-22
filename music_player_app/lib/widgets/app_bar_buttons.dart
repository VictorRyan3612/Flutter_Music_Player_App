import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:music_player_app/data/music_data_service.dart';

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
          valueListenable: musicDataService.newplaylist,
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

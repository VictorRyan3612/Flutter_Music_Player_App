import 'package:flutter/material.dart';
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

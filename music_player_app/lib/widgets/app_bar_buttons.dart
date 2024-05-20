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
      title: ValueListenableBuilder(
        valueListenable: musicDataService.musicsValueNotifier,
        builder: (context, value, child) {
          return Text('${value['data'].length}');
        }
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/widgets/play_button.dart';


class MusicPlayingScreen extends StatelessWidget {
  static const double _minSwipeDistance = 100.0;

  MusicPlayingScreen({super.key});


  @override
  Widget build(BuildContext context) {
  late Offset _initialPosition;
    return GestureDetector(
      child: ScreenMusic(),
      onVerticalDragStart: (details) {
        _initialPosition = details.globalPosition;
      },
      onVerticalDragUpdate: (details) {
        final distance = details.globalPosition.dy - _initialPosition.dy;

        if (distance > _minSwipeDistance) {
          Navigator.pop(context);
        }
      },
    );
  }
}
class ScreenMusic extends HookWidget {
  const ScreenMusic({super.key});

  @override
  Widget build(BuildContext context) {
    var color = useState(musicDataService.shuffle == true ? Theme.of(context).primaryColor : Colors.grey);
    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(
            color: color.value,
            icon: Icon(Icons.shuffle),
            onPressed: () {
              musicDataService.toggleShuffle();
              if (musicDataService.shuffle) {
                color.value = Theme.of(context).primaryColor;
              } else {
                color.value = Colors.grey;
              }
            }),IconButton(
            icon: Icon(Icons.repeat),
            onPressed: () {

            }),IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {

            }),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: musicDataService.actualPlayingMusic,
        builder: (context, value, child) {
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${value.trackName}', style: TextStyle(fontSize: 22),),
                      Text('${value.albumArtistName} - ${value.albumName}'),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Image.memory(value.albumArt!, width: 400, height: 400,),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.skip_previous),
                    onPressed: () {
                      
                      musicDataService.previousMusic();
                  }),
          
                  PlayButton(),
          
                  IconButton(
                    icon: Icon(Icons.skip_next),
                    onPressed: () async{
                      musicDataService.nextMusic();
                  }),
                ],
              )
            ],
          );
        }
      ),
    );
  }
}
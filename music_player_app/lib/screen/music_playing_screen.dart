import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/widgets/play_button.dart';

class MusicPlayingScreen extends StatelessWidget {
  late Offset _initialPosition;

  static const double _minSwipeDistance = 100.0;

  MusicPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
class ScreenMusic extends StatelessWidget {
  const ScreenMusic({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        actions: [
          IconButton(
            icon: Icon(Icons.shuffle),
            onPressed: () {

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
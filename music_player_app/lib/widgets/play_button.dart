import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/data/music_data_service.dart';


class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isStopped = false;
    return StreamBuilder<PlayerState>(
      stream: musicDataService.player.playerStateStream,
      builder: (context, snapshot) {
        musicDataService.player.playerStateStream.listen((event) {
          if (event.processingState == ProcessingState.ready && isStopped == false){
            musicDataService.player.play();
          }
          
        });

        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            // width: 64.0,
            // height: 64.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true && processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.play_arrow),
            // iconSize: 64.0,
            onPressed: (){
              isStopped = false;
              musicDataService.player.play();

            }
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: const Icon(Icons.pause),
            // iconSize: 64.0,
            onPressed: (){
              isStopped = true;
              musicDataService.player.pause();
            }
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            // iconSize: 64.0,
            onPressed: () => musicDataService.player.seek(Duration.zero),
          );
        }
      },
    );
  }
}

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player_app/data/music_data_service.dart';


class PlayButton extends StatefulWidget {
  const PlayButton({Key? key}) : super(key: key);

  @override
  PlayButtonState createState() => PlayButtonState();
}

class PlayButtonState extends State<PlayButton> {
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> sessionFunction() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }
  
  Future<void> _init() async {
    sessionFunction();
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    // Try to load audio from a source and catch any errors.
    try {
      // AAC example: https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.aac
      await _player.setAudioSource(AudioSource.file(musicDataService.actualPlayingMusic.value.filePath as String));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  /// Collects the data useful for displaying in a seek bar, using a handy
  /// feature of rx_dart to combine the 3 streams of interest into one.
  
  @override
  Widget build(BuildContext context) {
    return ControlButtons(_player);
  }
}

/// Displays the play/pause button and volume/speed sliders.
class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: musicDataService.actualPlayingMusic,
      builder: (context, value, child) {
        if(value.filePath !=null){
          
          player.setAudioSource(AudioSource.file((value.filePath as String)));
        }
        return StreamBuilder<PlayerState>(
              stream: player.playerStateStream,
              builder: (context, snapshot) {
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
                } else if (playing != true) {
                  return IconButton(
                    icon: const Icon(Icons.play_arrow),
                    // iconSize: 64.0,
                    onPressed: player.play,
                  );
                } else if (processingState != ProcessingState.completed) {
                  return IconButton(
                    icon: const Icon(Icons.pause),
                    // iconSize: 64.0,
                    onPressed: player.pause,
                  );
                } else {
                  return IconButton(
                    icon: const Icon(Icons.replay),
                    // iconSize: 64.0,
                    onPressed: () => player.seek(Duration.zero),
                  );
                }
              },
            );
      }
    );
        // Opens speed slider dialog
      
  }
}

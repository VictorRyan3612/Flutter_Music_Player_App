import 'dart:io';
import 'dart:ui';

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
    var colorShuffle = useState(musicDataService.shuffle == true ? Theme.of(context).primaryColor : Colors.grey);
    var colorRepeat = useState(musicDataService.repeat == true ? Theme.of(context).primaryColor : Colors.grey);

    void iconColor(ValueNotifier<Color> color, bool bool) {
      if (bool) {
        color.value = Theme.of(context).primaryColor;
      } else {
        color.value = Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: colorShuffle.value,
            icon: Icon(Icons.shuffle),
            onPressed: () {
              musicDataService.toggleShuffle();
              iconColor(colorShuffle, musicDataService.shuffle);
            }
          ),
          IconButton(
            color: colorRepeat.value,
            icon: Icon(Icons.repeat),
            onPressed: () {
              musicDataService.toggleRepeat();
              iconColor(colorRepeat, musicDataService.repeat);
            }
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              // musicDataService.createPlaylist('teste', musicDataService.actualPlaylist.value['playlist']);
            }
          ),
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: musicDataService.actualPlayingMusic,
          builder: (context, value, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                
                musicDataService.actualPlayingMusic.value['albumArtPath'] != null ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(musicDataService.actualPlayingMusic.value['albumArtPath']!),
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.8),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ],
                ) : Container(),

                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${value['trackName']}',
                              style: TextStyle(fontSize: 22),
                            ),
                            Text('${value['albumArtistName']} - ${value['albumName']}'),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: value['albumArtPath'] != null ?Image.file(
                          File(value['albumArtPath']!) ,
                          width: 400,
                          height: 400,
                        ) : Icon(Icons.music_note, weight: 400, size: 400,),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          icon: Icon(Icons.skip_previous),
                          onPressed: () {
                            musicDataService.previousMusic();
                          }
                        ),
                        PlayButton(),
                        IconButton(
                          icon: Icon(Icons.skip_next),
                          onPressed: () async {
                            musicDataService.nextMusic();
                          }
                        ),
                      ],
                    )
                  ],
                ),
              ],
            );
          }
      ),
    );
  }
}

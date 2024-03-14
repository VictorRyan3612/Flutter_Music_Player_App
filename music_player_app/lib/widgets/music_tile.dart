import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:music_player_app/data/music_data_service.dart';

class MusicTile extends StatelessWidget {
  final Metadata music;
  const MusicTile({
    super.key, required this.music,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${music.trackName}", style: TextStyle(fontSize: 20),),
      subtitle: Text("${music.albumArtistName} - ${music.albumName}", style: TextStyle(fontSize: 15)),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Builder(
            builder: (context) {
              if (music.trackDuration == null){
                return Text('00:00',style: TextStyle(fontSize: 15));
              }
              return Text(
                "${musicDataService.formatMilliseconds(music.trackDuration!)}",
                style: TextStyle(fontSize: 15),
              );
            },
            
          ),
        ],
      ),
      leading: Builder(
        builder: (context) {
          try {
            return Image.memory(music.albumArt!);
          } catch (e) {
            return Icon(Icons.music_note);
          }
        },
      ),
    
    );
  }
}
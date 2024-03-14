import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class ListMusics extends StatelessWidget {
  const ListMusics({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: musicDataService.loadMusicsDatas(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else {
            return ValueListenableBuilder(
              valueListenable: musicDataService.musicsValueNotifier,
              builder: (context, value, child) {
                switch (value['status']) {
                  case TableStatus.loading:
                    return Center(child: CircularProgressIndicator());
                  case TableStatus.error:
                  return Center(
                    child: Text("Error"),
                  );
                  case TableStatus.ready:
                    return ListView.builder(
                      itemCount:value['objects'].length,
                      itemBuilder: (context, index) {
                        return MusicTile(music: value['objects'][index],);
                      }
                    );
                } return Container();
              }
            );
          }
        }
      )
    );
  }
}

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
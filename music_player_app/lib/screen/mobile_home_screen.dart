import 'package:flutter/material.dart';
import 'package:music_player_app/data/music_data_service.dart';


class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music"),
        leading: Icon(Icons.menu),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ValueListenableBuilder(
          valueListenable: musicDataService.musicsValueNotifier,
          builder: (context, value, child) {
            // print(value['objects']);
            return ListView.builder(
              itemCount: value['objects'].length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("${value['objects'][index].trackName}", style: TextStyle(fontSize: 20),),
                  subtitle: Text("${value['objects'][index].albumArtistName} - ${value['objects'][index].albumName}", style: TextStyle(fontSize: 15)),
                  leading: Icon(Icons.music_note, size: 32),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "3:30",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      )
    );
  }
}

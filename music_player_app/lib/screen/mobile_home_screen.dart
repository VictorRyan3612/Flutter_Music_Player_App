import 'package:flutter/material.dart';


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
        child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Music Name", style: TextStyle(fontSize: 20),),
              subtitle: Text("Artist Name - Album Name", style: TextStyle(fontSize: 15)),
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
        ),
      )
    );
  }
}

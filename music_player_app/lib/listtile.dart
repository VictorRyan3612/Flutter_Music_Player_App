import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListTile sheet'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(""),
            SheetButton()
          ],
        ),
      )
        
    );
  }
}

class SheetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      
      leading: IconButton(
        icon: Icon(
          Icons.play_arrow,
          ),
        onPressed: () {
          
        },
      ),
      title: Text("title"),
      subtitle: Text("Album e artista"),
      onTap: () {
        
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

class SheetTile extends StatelessWidget {
  final Metadata? music;
  const SheetTile({super.key, this.music});
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

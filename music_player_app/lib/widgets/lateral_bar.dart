import 'package:flutter/material.dart';
import 'package:flutter_vicr_widgets/flutter_vicr_widgets.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';

class LateralBar extends StatelessWidget {
  const LateralBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ExtensibleLateralBar(
      items: [
        ExtensibleLateralBarItem(
          icon: Icon(Icons.home), 
          title: Text("Home"), 
          onTap: (){
            settingsService.listingTags.value = false;
            settingsService.listingPlaylist = false;
            musicDataService.saveValueNotifier(musicDataService.originalList);
            
            settingsService.tag.value = '';
          }
        ),
        ExtensibleLateralBarItem(
          icon: Icon(Icons.people), 
          title: Text("Artistas"), 
          onTap: (){
            settingsService.listingTags.value = true;
            settingsService.listingPlaylist = false;
            musicDataService.actualTag.value = musicDataService.setAlbumArtistName;
          }
        ),
        ExtensibleLateralBarItem(
          icon: Icon(Icons.library_music), 
          title: Text("Albums"), 
          onTap: (){
            settingsService.listingTags.value = true;
            settingsService.listingPlaylist = false;
            musicDataService.actualTag.value = musicDataService.setAlbumName;
          }
        ),
        ExtensibleLateralBarItem(
          icon: Icon(Icons.music_note), 
          title: Text("Generos"), 
          onTap: (){
            settingsService.listingTags.value = true;
            settingsService.listingPlaylist = false;
            musicDataService.actualTag.value = musicDataService.setGenders;
          }
        ),
        ExtensibleLateralBarItem(
          icon: Icon(Icons.playlist_play), 
          title: Text("Playlist"), 
          onTap: (){
            settingsService.listingTags.value = true;
            settingsService.listingPlaylist = true;
            musicDataService.actualTag.value = musicDataService.playlistsService.setPlaylistsNames;
            
          }
        ),
      ],
      trailingItems: [
        ExtensibleLateralBarItem(
            icon: Icon(Icons.settings),
            title: Text("Configuracoes"),
            onTap: () {
              Navigator.pushNamed(context, '/configs');
            },
          )

      ],
      
    );
  }
}
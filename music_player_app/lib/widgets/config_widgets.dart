import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/files_service.dart';
import 'package:music_player_app/data/music_data_service.dart';

List<Widget> listWidgets = [
  ListTile(
    title: Text("Modo de Visualização em Tabela"),
    trailing: ValueListenableBuilder(
      valueListenable: settingsService.isTable,
      builder: (context, valueIsTable, child) {
        return Switch(
          value: valueIsTable, 
          onChanged: (valueOnChanged) {
            settingsService.isTable.value = valueOnChanged;
            settingsService.saveSettings();
          },
        );
      }
    ),
    
  ),

  ListTile(
    title: Text("Repetição da musica na fila de reprodução se em loop"),
    subtitle: Text("Com loop ativado, a música deve aparecer mais uma vez na fila de reprodução"),
    trailing: ValueListenableBuilder(
      valueListenable: settingsService.addRepeat,
      builder: (context, valueAddRepeat, child) {
        return Switch(
          value: valueAddRepeat, 
          onChanged: (valueOnChanged) {
            settingsService.addRepeat.value = valueOnChanged;
            musicDataService.addRepeat = valueOnChanged;
            print('settings: ${settingsService.addRepeat.value}\ndata:${musicDataService.addRepeat}');
            settingsService.saveSettings();
          },
        );
      }
    ),
    
  ),
  
  ListTile(
    title: Text("Selecionar Pastas"),
    onTap: () async {
      String? folder = await FilePicker.platform.getDirectoryPath();
      
      if (folder != null) {
        print('Pasta selecionada: $folder');
        Directory directory = Directory(folder);
        settingsService.saveSettings();
        musicDataService.addFolderPath(directory);
      } else {
        print('Nenhuma pasta selecionada.');
      }

    },
  ),

  ListTile(
    title: Text("Remover Pastas"),
    onTap: () async {
      String? folder = await FilePicker.platform.getDirectoryPath();
      
      if (folder != null) {
        print('Pasta selecionada: $folder');
        settingsService.saveSettings();
        filesService.removeFolderPath(folder);
        
      } else {
        print('Nenhuma pasta selecionada.');
      }

    },
  ),
  ListTile(
    title: Text("Exportar Todas as playlists"),
    onTap: () async {
      String? folder = await FilePicker.platform.getDirectoryPath();
      
      if (folder != null) {
        print('Pasta selecionada: $folder');
        settingsService.saveSettings();
        musicDataService.playlistsService.exportAllPlaylist(folder);
        
      } else {
        print('Nenhuma pasta selecionada.');
      }

    },
  ),
];
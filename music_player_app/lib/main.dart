import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_vicr_widgets/flutter_vicr_widgets.dart';

import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/config/theme_config.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/screen/desktop_home_screen.dart';
import 'package:music_player_app/screen/mobile_home_screen.dart';



void main() {
  settingsService.loadSettings().whenComplete(() {
      musicDataService.setConfigs(
        listFoldersPaths: settingsService.listFoldersPaths.value,
        repeat: settingsService.repeat,
        addRepeat: settingsService.addRepeat.value,
        shuffle: settingsService.shuffle
      );
    });
    
  VictMaterialApp().loadSettings();

  runApp(VictMaterialApp(
    configWidget: ConfigWidgets(
      trailingWidgets: listWidgets
    ),
    routes: {
      '/': (context) => LayoutDecider(
        isMobile: settingsService.isMobile,
        optionMobile: MobileHomeScreen(),
        optionDesktop: DesktopHomeScreen(),
      ),
    }
  ));
}


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
        settingsService.saveSettings();
        musicDataService.addFolderPath(folder);
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
        musicDataService.removeFolderPath(folder);
        
      } else {
        print('Nenhuma pasta selecionada.');
      }

    },
  ),
];
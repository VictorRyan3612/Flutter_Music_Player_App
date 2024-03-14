import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';


class ConfigScreen extends StatelessWidget {
  final ValueNotifier<bool> currentIsDarkMode;
  final ValueNotifier<String> currentColor;

  const ConfigScreen({super.key, required this.currentIsDarkMode, required this.currentColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configurações"),),

      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Modo Escuro"),
                    // subtitle: Text(""),
                    trailing: Switch(
                      value: currentIsDarkMode.value, 
                      onChanged: (value) {
                        currentIsDarkMode.value = value;
                        settingsService.isDarkMode.value = value;
                        settingsService.saveSettings();
                      },
                    ),
                    
                  ),
                  Divider(),
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

                  Divider(),
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
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

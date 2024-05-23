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
                  Divider(),
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

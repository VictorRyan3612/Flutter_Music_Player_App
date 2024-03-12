import 'package:flutter/material.dart';
import 'package:music_player_app/config/settings_data_service.dart';


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
                        settingsService.saveSettings(currentIsDarkMode.value);
                      },
                    ),
                    
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Opção 2"),
                    subtitle: Text("Subtitulo 2"),
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Opção 3"),
                    subtitle: Text("Subtitulo 3"),
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

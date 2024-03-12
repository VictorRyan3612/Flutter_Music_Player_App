import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/config/theme_config.dart';
import 'package:music_player_app/screen/config_screen.dart';
import 'package:music_player_app/view/builder_layout.dart';



void main() {
  runApp(const MainApp());
}

class MainApp extends HookWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    // base states 
    final currentIsDarkMode = useState(true); //Theme
    final currentColor = useState('Blue'); // Accent color

    settingsService.loadSettings().whenComplete(() {
      currentIsDarkMode.value = settingsService.isDarkMode.value;
      currentColor.value = settingsService.colorName.value;
    });
      

    final finalTheme = setTheme(currentIsDarkMode.value, currentColor.value);

    return MaterialApp(
      theme: finalTheme,
      debugShowCheckedModeBanner: false,
      

      // home: BuilderLayout()

      initialRoute: '/configs',
      routes: {
        '/': (context) => BuilderLayout(),
        '/configs': (context) => ConfigScreen(
          currentIsDarkMode: currentIsDarkMode,
          currentColor: currentColor,
          )
      }
    );
  }
}

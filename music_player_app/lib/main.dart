import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/config/theme_config.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/layout/layout.dart';
import 'package:music_player_app/screen/config_screen.dart';
import 'package:music_player_app/screen/desktop_home_screen.dart';
import 'package:music_player_app/screen/mobile_home_screen.dart';



void main() {
  settingsService.loadSettings().whenComplete(() {
      musicDataService.setConfigs(
        listFoldersPaths: settingsService.listFoldersPaths.value,
        repeat: settingsService.repeat.value,
        addRepeat: settingsService.addRepeat.value,
        shuffle: settingsService.shuffle.value
      );
    });
  runApp(const MainApp());
}

class MainApp extends HookWidget {
  const MainApp({super.key});


  @override
  Widget build(BuildContext context) {
    // base states 
    final currentIsDarkMode = useState(settingsService.isDarkMode.value); //Theme
    final currentColor = useState(settingsService.colorName.value); // Accent color

    
      

    final finalTheme = setTheme(currentIsDarkMode.value, currentColor.value);

    return MaterialApp(
      theme: finalTheme,
      debugShowCheckedModeBanner: false,
      

      // home: BuilderLayout()

      initialRoute: '/',
      routes: {
        // '/': (context) => LayoutDecididor2(),
        
        '/': (context) => LayoutDecider(
          isMobile: settingsService.isMobile,
          optionMobile: MobileHomeScreen(),
          optionDesktop: DesktopHomeScreen(),
        ),
        '/configs': (context) => ConfigScreen(
          currentIsDarkMode: currentIsDarkMode,
          currentColor: currentColor,
          )
      }
    );
  }
}

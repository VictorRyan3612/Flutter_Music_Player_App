import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/config/theme_config.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/layout/layout.dart';
import 'package:music_player_app/screen/config_screen.dart';
import 'package:music_player_app/view/builder_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

    Future<void> loadSettings() async {
      final prefs = await SharedPreferences.getInstance();
      
      final isDarkMode = prefs.getBool('isDarkMode') ?? true;
      currentIsDarkMode.value = isDarkMode;

      final colorTheme = prefs.getString('colorTheme') ?? 'Blue';
      currentColor.value = colorTheme;

    }

    loadSettings();
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

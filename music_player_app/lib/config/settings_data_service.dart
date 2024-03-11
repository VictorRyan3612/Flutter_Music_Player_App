import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsService{
  ValueNotifier<bool> isMobile = ValueNotifier(false);
  ValueNotifier<bool> isDarkMode = ValueNotifier(true);
  ValueNotifier<String> colorName = ValueNotifier('Blue');


  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    final isDarkMode = prefs.getBool('isDarkMode') ?? settingsService.isDarkMode.value;
    settingsService.isDarkMode.value = isDarkMode;

    final colorTheme = prefs.getString('colorTheme') ?? settingsService.colorName.value;
    settingsService.colorName.value = colorTheme;
  }

  Future<void> saveSettings(bool boolIsDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    
    prefs.setBool('isDarkMode', boolIsDarkMode);
    prefs.setString('colorTheme', colorName.value);

  }
}

SettingsService settingsService = SettingsService();

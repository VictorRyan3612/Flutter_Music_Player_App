import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsService{
  ValueNotifier<bool> isMobile = ValueNotifier(false);
  ValueNotifier<bool> isDarkMode = ValueNotifier(true);
  ValueNotifier<String> colorName = ValueNotifier('Blue');
  ValueNotifier<List<String>> listFolders = ValueNotifier([]);

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? settingsService.isDarkMode.value;
    settingsService.isDarkMode.value = isDarkMode;

    
    final colorTheme = prefs.getString('colorTheme') ?? settingsService.colorName.value;
    settingsService.colorName.value = colorTheme;

    final listFolders = prefs.getStringList('listFolders') ?? settingsService.listFolders.value;
    settingsService.listFolders.value = listFolders;
  }

  Future<void> saveSettings(bool boolIsDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    
    prefs.setBool('isDarkMode', boolIsDarkMode);
    prefs.setString('colorTheme', colorName.value);

  }
  Future<void> saveFolders(List<String> listFolders) async {
    final prefs = await SharedPreferences.getInstance();
    
    prefs.setStringList('listFolders', listFolders);

  }
}

SettingsService settingsService = SettingsService();

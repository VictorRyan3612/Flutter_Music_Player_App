import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsService{
  ValueNotifier<bool> isMobile = ValueNotifier(false);
  ValueNotifier<bool> isDarkMode = ValueNotifier(true);
  ValueNotifier<String> colorName = ValueNotifier('Blue');
  ValueNotifier<List<String>> listFoldersPaths = ValueNotifier([]);

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? settingsService.isDarkMode.value;
    settingsService.isDarkMode.value = isDarkMode;

    
    final colorTheme = prefs.getString('colorTheme') ?? settingsService.colorName.value;
    settingsService.colorName.value = colorTheme;

    final listFoldersPaths = prefs.getStringList('listFoldersPaths') ?? settingsService.listFoldersPaths.value;
    settingsService.listFoldersPaths.value = listFoldersPaths;
  }

  Future<void> saveSettings(bool boolIsDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    
    prefs.setBool('isDarkMode', boolIsDarkMode);
    prefs.setString('colorTheme', colorName.value);

  }
  Future<void> saveFolders(List<String> listFoldersPaths) async {
    final prefs = await SharedPreferences.getInstance();
    
    prefs.setStringList('listFoldersPaths', listFoldersPaths);

  }
}

SettingsService settingsService = SettingsService();

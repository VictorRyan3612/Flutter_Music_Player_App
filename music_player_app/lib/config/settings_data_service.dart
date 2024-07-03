import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsService{
  ValueNotifier<bool> isMobile = ValueNotifier(false);
  // ValueNotifier<bool> isDarkMode = ValueNotifier(true);
  // ValueNotifier<String> colorName = ValueNotifier('Blue');
  ValueNotifier<List<String>> listFoldersPaths = ValueNotifier([]);
  ValueNotifier<bool> listingTags = ValueNotifier(false);
  ValueNotifier<String> tag = ValueNotifier('');
  bool listingPlaylist = false;

  bool shuffle = true;
  bool repeat = false;
  ValueNotifier<bool> addRepeat = ValueNotifier(false);
  ValueNotifier<bool> isSelecting = ValueNotifier(false);
  ValueNotifier<bool> isTable = ValueNotifier(false);


  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // final isDarkMode = prefs.getBool('isDarkMode') ?? settingsService.isDarkMode.value;
    // settingsService.isDarkMode.value = isDarkMode;

    // final colorTheme = prefs.getString('colorTheme') ?? settingsService.colorName.value;
    // settingsService.colorName.value = colorTheme;


    final shuffle = prefs.getBool('shuffle') ?? settingsService.shuffle;
    settingsService.shuffle = shuffle;

    final repeat = prefs.getBool('repeat') ?? settingsService.repeat;
    settingsService.repeat = repeat;

    final addRepeat = prefs.getBool('addRepeat') ?? settingsService.addRepeat.value;
    settingsService.addRepeat.value = addRepeat;
    
    final isTable = prefs.getBool('isTable') ?? settingsService.isTable.value;
    settingsService.isTable.value = isTable;

    final listFoldersPaths = prefs.getStringList('listFoldersPaths') ?? settingsService.listFoldersPaths.value;
    settingsService.listFoldersPaths.value = listFoldersPaths;
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    // prefs.setBool('isDarkMode', isDarkMode.value);
    // prefs.setString('colorTheme', colorName.value);
    prefs.setBool('addRepeat', addRepeat.value);
    prefs.setBool('repeat', repeat);
    prefs.setBool('shuffle', shuffle);
    prefs.setBool('isTable', isTable.value);
    prefs.setStringList('listFoldersPaths', listFoldersPaths.value);
  }
  
}

SettingsService settingsService = SettingsService();

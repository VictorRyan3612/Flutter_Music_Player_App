import 'package:flutter/material.dart';
import 'package:flutter_vicr_widgets/flutter_vicr_widgets.dart';

import 'package:music_player_app/config/settings_data_service.dart';
import 'package:music_player_app/data/music_data_service.dart';
import 'package:music_player_app/screen/desktop_home_screen.dart';
import 'package:music_player_app/screen/mobile_home_screen.dart';
import 'package:music_player_app/widgets/config_widgets.dart';



void main() {
  settingsService.loadSettings().whenComplete(() {
      musicDataService.setConfigs(
        listFoldersPaths: settingsService.listFoldersPaths.value,
        repeat: settingsService.repeat,
        addRepeat: settingsService.addRepeat.value,
        shuffle: settingsService.shuffle
      );
    });
    
  VictMaterialApp().loadSettings();

  runApp(VictMaterialApp(
    configWidget: ConfigWidgets(
      trailingWidgets: listWidgets
    ),
    routes: {
      '/': (context) => LayoutDecider(
        isMobile: settingsService.isMobile,
        optionMobile: MobileHomeScreen(),
        optionDesktop: DesktopHomeScreen(),
      ),
    }
  ));
}


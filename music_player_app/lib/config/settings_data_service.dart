import 'package:flutter/widgets.dart';

class SettingsService{
  ValueNotifier<bool> isMobile = ValueNotifier(false);
}

SettingsService settingsService = SettingsService();

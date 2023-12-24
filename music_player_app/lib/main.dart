import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:music_player_app/layout/layout.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: finalTheme,
      debugShowCheckedModeBanner: false,


      initialRoute: '/',
      routes: {
        '/': (context) => LayoutDecider(),
      }
    );
  }
}
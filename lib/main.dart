import 'package:flutter/material.dart';
import 'package:tileseteditor/app.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle('TileSet Editor');
  });

  runApp(const TileSetMaterialApp());
}

class TileSetMaterialApp extends StatelessWidget {
  const TileSetMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TileSet Editor',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: TileSetEditorApp(),
    );
  }
}

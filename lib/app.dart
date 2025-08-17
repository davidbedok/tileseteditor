import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/menubar.dart';

class TileSetEditorApp extends StatelessWidget {
  const TileSetEditorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Shortcuts(
        shortcuts: <ShortcutActivator, Intent>{
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): VoidCallbackIntent(() {
            print('Open New project dialog (global)..');
          }),
          const SingleActivator(LogicalKeyboardKey.keyT, control: true): VoidCallbackIntent(() {
            debugDumpApp();
          }),
        },
        child: Scaffold(
          body: SafeArea(child: TileSetEditorMenuBar()),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print('hello');
            },
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

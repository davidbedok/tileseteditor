import 'dart:ui' as dui;

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/output/output_editor.dart';
import 'package:tileseteditor/splitter/splitter_editor.dart';
import 'package:tileseteditor/splitter/state/editor_state.dart';

class TileSetEditor extends StatefulWidget {
  static const int topHeight = 210;

  final TileSetProject project;
  final TileSet tileSet;
  final dui.Image tileSetImage;
  final EditorState editorState;

  const TileSetEditor({super.key, required this.project, required this.tileSet, required this.tileSetImage, required this.editorState});

  @override
  State<TileSetEditor> createState() => _TileSetEditorState();
}

class _TileSetEditorState extends State<TileSetEditor> {
  bool outputEditor = false;

  @override
  Widget build(BuildContext context) {
    return outputEditor
        ? OutputEditor(
            widget: widget,
            onSplitterPressed: () {
              setState(() {
                outputEditor = false;
              });
            },
          )
        : SplitterEditor(
            widget: widget,
            onOutputPressed: () {
              setState(() {
                outputEditor = true;
              });
            },
          );
  }
}

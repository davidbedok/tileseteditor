import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/output/output_editor.dart';
import 'package:tileseteditor/output/state/output_editor_state.dart';
import 'package:tileseteditor/splitter/splitter_editor.dart';
import 'package:tileseteditor/splitter/state/splitter_editor_state.dart';

class TileSetEditor extends StatefulWidget {
  static const int topHeight = 210;

  final TileSetProject project;
  final TileSet tileSet;
  final SplitterEditorState splitterState;
  final OutputEditorState outputState;

  const TileSetEditor({
    super.key, //
    required this.project,
    required this.tileSet,
    required this.splitterState,
    required this.outputState,
  });

  @override
  State<TileSetEditor> createState() => _TileSetEditorState();
}

class _TileSetEditorState extends State<TileSetEditor> {
  bool outputEditor = false;

  @override
  Widget build(BuildContext context) {
    return outputEditor
        ? OutputEditor(
            project: widget.project,
            tileSet: widget.tileSet,
            outputState: widget.outputState,
            onSplitterPressed: () {
              setState(() {
                outputEditor = false;
              });
            },
          )
        : SplitterEditor(
            project: widget.project,
            tileSet: widget.tileSet,
            splitterState: widget.splitterState,
            onOutputPressed: () {
              setState(() {
                outputEditor = true;
              });
            },
          );
  }
}

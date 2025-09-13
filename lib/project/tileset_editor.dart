import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/output/tileset/tileset_output_editor.dart';
import 'package:tileseteditor/output/tileset/tileset_output_state.dart';
import 'package:tileseteditor/splitter/splitter_editor.dart';
import 'package:tileseteditor/splitter/splitter_state.dart';

class TileSetEditor extends StatefulWidget {
  final YateProject project;
  final TileSet tileSet;
  final SplitterState splitterState;
  final TileSetOutputState outputState;

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
        ? TileSetOutputEditor(
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

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/group/group_editor.dart';
import 'package:tileseteditor/group/group_state.dart';
import 'package:tileseteditor/output/tilegroup/tilegroup_output_editor.dart';
import 'package:tileseteditor/output/output_state.dart';

class TileGroupEditor extends StatefulWidget {
  final YateProject project;
  final TileGroup tileGroup;
  final GroupState groupState;
  final OutputState outputState;

  const TileGroupEditor({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.groupState,
    required this.outputState,
  });

  @override
  State<TileGroupEditor> createState() => _TileGroupEditorState();
}

class _TileGroupEditorState extends State<TileGroupEditor> {
  bool outputEditor = false;

  @override
  Widget build(BuildContext context) {
    return outputEditor
        ? TileGroupOutputEditor(
            project: widget.project,
            tileGroup: widget.tileGroup,
            outputState: widget.outputState,
            onSplitterPressed: () {
              setState(() {
                outputEditor = false;
              });
            },
          )
        : GroupEditor(
            project: widget.project,
            tileGroup: widget.tileGroup,
            groupState: widget.groupState,
            onOutputPressed: () {
              setState(() {
                outputEditor = true;
              });
            },
          );
  }
}

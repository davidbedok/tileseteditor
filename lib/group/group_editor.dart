import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/group/group_controller.dart';
import 'package:tileseteditor/group/group_state.dart';

class GroupEditor extends StatefulWidget {
  static const int topHeight = 230;

  final TileSetProject project;
  final TileGroup tileGroup;
  final GroupState groupState;

  const GroupEditor({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.groupState,
  });

  @override
  State<GroupEditor> createState() => _GroupEditorState();
}

class _GroupEditorState extends State<GroupEditor> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GroupController(
              project: widget.project, //
              tileGroup: widget.tileGroup,
              groupState: widget.groupState,
            ),
            Row(children: [Text('bbbbb')]),
          ],
        ),
      ],
    );
  }
}

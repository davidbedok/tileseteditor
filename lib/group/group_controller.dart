import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/group/group_state.dart';

class GroupController extends StatefulWidget {
  final TileSetProject project;
  final TileGroup tileGroup;
  final GroupState groupState;
  final void Function() onAddTiles;

  const GroupController({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.groupState,
    required this.onAddTiles,
  });

  @override
  State<GroupController> createState() => GroupControllerState();
}

class GroupControllerState extends State<GroupController> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.add), //
            label: Text('Add tiles (*.png)'),
            onPressed: widget.onAddTiles,
          ),
        ],
      ),
    );
  }
}

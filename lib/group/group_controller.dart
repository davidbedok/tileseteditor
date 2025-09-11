import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';
import 'package:tileseteditor/group/group_state.dart';

class GroupController extends StatefulWidget {
  final TileSetProject project;
  final TileGroup tileGroup;
  final GroupState groupState;
  final void Function() onAddTiles;
  final void Function() onRemoveTiles;
  final void Function() onOutputPressed;

  const GroupController({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.groupState,
    required this.onAddTiles,
    required this.onRemoveTiles,
    required this.onOutputPressed,
  });

  @override
  State<GroupController> createState() => GroupControllerState();
}

class GroupControllerState extends State<GroupController> {
  late int numberOfSelectedFiles;

  @override
  void initState() {
    super.initState();
    numberOfSelectedFiles = widget.groupState.selectedFiles.length;
    widget.groupState.subscribeSelection(select);
    widget.groupState.subscribeSelectioAll(selectAll);
  }

  @override
  void dispose() {
    super.dispose();
    widget.groupState.unsubscribeSelection(select);
    widget.groupState.unsubscribeSelectionAll(selectAll);
  }

  void select(GroupState state, TileGroupFile groupFile) {
    setState(() {
      numberOfSelectedFiles = state.selectedFiles.length;
    });
  }

  void selectAll(GroupState state, bool select) {
    setState(() {
      numberOfSelectedFiles = state.selectedFiles.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.select_all),
            onPressed: () {
              widget.groupState.selectAll(widget.tileGroup);
              setState(() {
                numberOfSelectedFiles = widget.groupState.selectedFiles.length;
              });
            },
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.deselect),
            onPressed: () {
              widget.groupState.deselectAll();
              setState(() {
                numberOfSelectedFiles = widget.groupState.selectedFiles.length;
              });
            },
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.add), //
            label: Text('Add tiles (*.png)'),
            onPressed: widget.onAddTiles,
          ),
          SizedBox(width: 5),
          Visibility(
            visible: numberOfSelectedFiles > 0,
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete), //
              label: Text('Remove $numberOfSelectedFiles file${numberOfSelectedFiles > 1 ? 's' : ''}'),
              onPressed: widget.onRemoveTiles,
            ),
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.edit), //
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            label: Text('Output'),
            onPressed: widget.onOutputPressed,
          ),
        ],
      ),
    );
  }
}

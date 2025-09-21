import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';
import 'package:tileseteditor/builder/builder_state.dart';
import 'package:tileseteditor/utils/dialog_utils.dart';

class BuilderController extends StatefulWidget {
  final YateProject project;
  final TileGroup tileGroup;
  final BuilderState builderState;
  final void Function() onAddTiles;
  final void Function() onRemoveTiles;
  final void Function() onOutputPressed;

  const BuilderController({
    super.key, //
    required this.project,
    required this.tileGroup,
    required this.builderState,
    required this.onAddTiles,
    required this.onRemoveTiles,
    required this.onOutputPressed,
  });

  @override
  State<BuilderController> createState() => BuilderControllerState();
}

class BuilderControllerState extends State<BuilderController> {
  late int numberOfSelectedFiles;

  @override
  void initState() {
    super.initState();
    numberOfSelectedFiles = widget.builderState.selectedFiles.length;
    widget.builderState.subscribeSelection(select);
    widget.builderState.subscribeSelectioAll(selectAll);
  }

  @override
  void dispose() {
    super.dispose();
    widget.builderState.unsubscribeSelection(select);
    widget.builderState.unsubscribeSelectionAll(selectAll);
  }

  void select(BuilderState state, TileGroupFile groupFile) {
    setState(() {
      numberOfSelectedFiles = state.selectedFiles.length;
    });
  }

  void selectAll(BuilderState state, bool select) {
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
          ElevatedButton.icon(
            icon: Icon(Icons.space_dashboard_outlined), //
            style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
            label: Text('Output'),
            onPressed: widget.onOutputPressed,
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.select_all),
            onPressed: () {
              widget.builderState.selectAll(widget.tileGroup);
              setState(() {
                numberOfSelectedFiles = widget.builderState.selectedFiles.length;
              });
            },
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.deselect),
            onPressed: () {
              widget.builderState.deselectAll();
              setState(() {
                numberOfSelectedFiles = widget.builderState.selectedFiles.length;
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
              onPressed: () async {
                if (await DialogUtils.confirmationDialog(
                  context,
                  'Remove $numberOfSelectedFiles file${numberOfSelectedFiles > 1 ? 's' : ''}',
                  'Are you sure you want to remove the selected file(s) from this tilegroup?',
                )) {
                  widget.onRemoveTiles.call();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

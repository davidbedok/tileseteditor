import 'package:flutter/material.dart';
import 'package:tileseteditor/dialogs/add_group_dialog.dart';
import 'package:tileseteditor/dialogs/add_slice_dialog.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/splitter/state/splitter_editor_state.dart';

class SplitterActionController extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final SplitterEditorState splitterState;
  final void Function() onOutputPressed;

  const SplitterActionController({
    super.key, //
    required this.project,
    required this.splitterState,
    required this.tileSet,
    required this.onOutputPressed,
  });

  @override
  State<SplitterActionController> createState() => SplitterActionControllerState();
}

class TileSetImage {}

class SplitterActionControllerState extends State<SplitterActionController> {
  int numberOfSelectedFreeTiles = 0;
  int numberOfSelectedGarbageTiles = 0;
  TileInfo? selectedSlice;
  TileInfo? selectedGroup;

  @override
  void initState() {
    super.initState();
    widget.splitterState.subscribeOnSelected(selectTile);
  }

  @override
  void dispose() {
    widget.splitterState.unsubscribeOnSelected(selectTile);
    super.dispose();
  }

  void selectTile(SplitterEditorState state, TileInfo tileInfo) {
    setState(() {
      numberOfSelectedFreeTiles = state.selectedFreeTiles.length;
      numberOfSelectedGarbageTiles = state.selectedGarbageTiles.length;
      selectedSlice = state.selectedSliceInfo;
      selectedGroup = state.selectedGroupInfo;
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
              widget.splitterState.selectAllFree(widget.tileSet);
              setState(() {
                numberOfSelectedFreeTiles = widget.splitterState.selectedFreeTiles.length;
              });
            },
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.deselect),
            onPressed: () {
              widget.splitterState.selectedFreeTiles.clear();
              setState(() {
                numberOfSelectedFreeTiles = widget.splitterState.selectedFreeTiles.length;
              });
            },
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            label: const Text('Slice'),
            onPressed: numberOfSelectedFreeTiles > 1
                ? () {
                    addSlice(context, widget.splitterState);
                  }
                : null,
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            label: numberOfSelectedFreeTiles > 1 ? Text('Group of $numberOfSelectedFreeTiles tiles') : const Text('Group'),
            onPressed: numberOfSelectedFreeTiles > 1
                ? () {
                    addGroup(context, widget.splitterState);
                  }
                : null,
          ),
          SizedBox(width: 5),
          Visibility(
            visible: numberOfSelectedFreeTiles > 0,
            child: ElevatedButton.icon(
              icon: Icon(Icons.cancel),
              label: Text('Drop $numberOfSelectedFreeTiles tiles'),
              onPressed: () {
                widget.tileSet.addGarbage(widget.splitterState.selectedFreeTiles);
                widget.splitterState.selectedFreeTiles.clear();
                setState(() {
                  numberOfSelectedFreeTiles = 0;
                });
              },
            ),
          ),
          SizedBox(width: 5),
          Visibility(
            visible: numberOfSelectedGarbageTiles > 0,
            child: ElevatedButton.icon(
              icon: Icon(Icons.cancel_outlined),
              label: Text('Undrop $numberOfSelectedGarbageTiles tiles'),
              onPressed: () {
                widget.tileSet.removeGarbage(widget.splitterState.selectedGarbageTiles);
                widget.splitterState.selectedGarbageTiles.clear();
                setState(() {
                  numberOfSelectedGarbageTiles = 0;
                });
              },
            ),
          ),
          SizedBox(width: 5),
          Visibility(
            visible: selectedSlice != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Delete ${selectedSlice != null ? selectedSlice!.name : ''}'),
              onPressed: () {
                widget.tileSet.remove(widget.splitterState.selectedSliceInfo!);
                widget.splitterState.selectedSliceInfo = null;
              },
            ),
          ),
          SizedBox(width: 5),
          Visibility(
            visible: selectedGroup != null,
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Delete ${selectedGroup != null ? selectedGroup!.name : ''}'),
              onPressed: () {
                widget.tileSet.remove(widget.splitterState.selectedGroupInfo!);
                widget.splitterState.selectedGroupInfo = null;
              },
            ),
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(icon: Icon(Icons.edit), label: Text('Output'), onPressed: widget.onOutputPressed),
        ],
      ),
    );
  }

  void addSlice(BuildContext context, SplitterEditorState editorState) async {
    TileSetSlice? dialogResult = await showDialog<TileSetSlice>(
      context: context,
      builder: (BuildContext context) {
        return AddSliceDialog(project: widget.project, tileSet: widget.tileSet, tiles: editorState.selectedFreeTiles);
      },
    );
    if (dialogResult != null) {
      widget.tileSet.addSlice(dialogResult);
      editorState.selectedFreeTiles.clear();
      setState(() {
        numberOfSelectedFreeTiles = 0;
      });
    }
  }

  void addGroup(BuildContext context, SplitterEditorState editorState) async {
    TileSetGroup? dialogResult = await showDialog<TileSetGroup>(
      context: context,
      builder: (BuildContext context) {
        return AddGroupDialog(project: widget.project, tileSet: widget.tileSet, tiles: editorState.selectedFreeTiles);
      },
    );
    if (dialogResult != null) {
      widget.tileSet.addGroup(dialogResult);
      editorState.selectedFreeTiles.clear();
      setState(() {
        numberOfSelectedFreeTiles = 0;
      });
    }
  }
}

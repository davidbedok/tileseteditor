import 'package:flutter/material.dart';
import 'package:tileseteditor/dialogs/add_group_dialog.dart';
import 'package:tileseteditor/dialogs/add_slice_dialog.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/state/editor_state.dart';

class EditorActionController extends StatefulWidget {
  final EditorState editorState;
  final TileSet tileSet;

  const EditorActionController({super.key, required this.editorState, required this.tileSet});

  @override
  State<EditorActionController> createState() => EditorActionControllerState();
}

class TileSetImage {}

class EditorActionControllerState extends State<EditorActionController> {
  int numberOfSelectedFreeTiles = 0;
  int numberOfSelectedGarbageTiles = 0;
  TileInfo? selectedSlice;
  TileInfo? selectedGroup;

  @override
  void initState() {
    super.initState();
    widget.editorState.subscribeOnSelected(selectTile);
  }

  @override
  void dispose() {
    widget.editorState.unsubscribeOnSelected(selectTile);
    super.dispose();
  }

  void selectTile(EditorState state, TileInfo tileInfo) {
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
              widget.editorState.selectAllFree(widget.tileSet);
              setState(() {
                numberOfSelectedFreeTiles = widget.editorState.selectedFreeTiles.length;
              });
            },
          ),
          SizedBox(width: 5),
          IconButton(
            icon: Icon(Icons.deselect),
            onPressed: () {
              widget.editorState.selectedFreeTiles.clear();
              setState(() {
                numberOfSelectedFreeTiles = widget.editorState.selectedFreeTiles.length;
              });
            },
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            label: const Text('Slice'),
            onPressed: numberOfSelectedFreeTiles > 1
                ? () {
                    addSlice(context, widget.editorState);
                  }
                : null,
          ),
          SizedBox(width: 5),
          ElevatedButton.icon(
            icon: Icon(Icons.add_circle_outline),
            label: numberOfSelectedFreeTiles > 1 ? Text('Group of $numberOfSelectedFreeTiles tiles') : const Text('Group'),
            onPressed: numberOfSelectedFreeTiles > 1
                ? () {
                    addGroup(context, widget.editorState);
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
                widget.tileSet.addGarbage(widget.editorState.selectedFreeTiles);
                widget.editorState.selectedFreeTiles.clear();
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
                widget.tileSet.removeGarbage(widget.editorState.selectedGarbageTiles);
                widget.editorState.selectedGarbageTiles.clear();
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
                widget.tileSet.remove(widget.editorState.selectedSliceInfo!);
                widget.editorState.selectedSliceInfo = null;
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
                widget.tileSet.remove(widget.editorState.selectedGroupInfo!);
                widget.editorState.selectedGroupInfo = null;
              },
            ),
          ),
        ],
      ),
    );
  }

  void addSlice(BuildContext context, EditorState editorState) async {
    TileSetSlice? dialogResult = await showDialog<TileSetSlice>(
      context: context,
      builder: (BuildContext context) {
        return AddSliceDialog(tileSet: widget.tileSet, tiles: editorState.selectedFreeTiles);
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

  void addGroup(BuildContext context, EditorState editorState) async {
    TileSetGroup? dialogResult = await showDialog<TileSetGroup>(
      context: context,
      builder: (BuildContext context) {
        return AddGroupDialog(tileSet: widget.tileSet, tiles: editorState.selectedFreeTiles);
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

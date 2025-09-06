import 'package:flutter/material.dart';
import 'package:tileseteditor/dialogs/add_group_dialog.dart';
import 'package:tileseteditor/dialogs/add_slice_dialog.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/splitter/splitter_state.dart';

class SplitterController extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final SplitterState splitterState;
  final void Function() onOutputPressed;

  const SplitterController({
    super.key, //
    required this.project,
    required this.splitterState,
    required this.tileSet,
    required this.onOutputPressed,
  });

  @override
  State<SplitterController> createState() => SplitterControllerState();
}

class TileSetImage {}

class SplitterControllerState extends State<SplitterController> {
  int numberOfSelectedFreeTiles = 0;
  int numberOfSelectedGarbageTiles = 0;
  late TileSetItem tileSetItem;

  @override
  void initState() {
    super.initState();
    tileSetItem = widget.splitterState.tileSetItem;
    widget.splitterState.subscribeSelection(selectTile);
  }

  @override
  void dispose() {
    widget.splitterState.unsubscribeSelection(selectTile);
    super.dispose();
  }

  void selectTile(SplitterState state, TileSetItem tileSetItem) {
    setState(() {
      numberOfSelectedFreeTiles = state.selectedFreeTiles.length;
      numberOfSelectedGarbageTiles = state.selectedGarbageTiles.length;
      this.tileSetItem = tileSetItem;
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
            visible: tileSetItem is TileSetSlice || tileSetItem is TileSetGroup,
            child: ElevatedButton.icon(
              icon: Icon(Icons.delete),
              label: Text('Delete ${tileSetItem.getLabel()}'),
              onPressed: () {
                widget.tileSet.remove(widget.splitterState.tileSetItem);
                widget.splitterState.unselectTileSetItem();
              },
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

  void addSlice(BuildContext context, SplitterState editorState) async {
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

  void addGroup(BuildContext context, SplitterState editorState) async {
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

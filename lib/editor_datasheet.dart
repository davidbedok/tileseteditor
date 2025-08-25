import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/state/editor_state.dart';

class EditorDatasheet extends StatefulWidget {
  final EditorState editorState;
  final TileSet tileSet;

  const EditorDatasheet({super.key, required this.editorState, required this.tileSet});

  @override
  State<EditorDatasheet> createState() => EditorDatasheetState();
}

class EditorDatasheetState extends State<EditorDatasheet> {
  // fixme: editorState can be the state here..
  int numberOfSelectedFreeTiles = 0;
  int numberOfSelectedGarbageTiles = 0;
  TileSetSlice? selectedSlice;
  TileSetGroup? selectedGroup;
  TileInfo? lastTile;

  @override
  void initState() {
    super.initState();
    widget.editorState.subscribeOnSelected(selectTile);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectTile(EditorState state, TileInfo tileInfo) {
    setState(() {
      lastTile = tileInfo;
      numberOfSelectedFreeTiles = state.selectedFreeTiles.length;
      numberOfSelectedGarbageTiles = state.selectedGarbageTiles.length;
      if (state.selectedSliceOrGroup != null) {
        selectedSlice = widget.tileSet.findSlice(state.selectedSliceOrGroup!.coord); // fixme..
        selectedGroup = widget.tileSet.findGroup(state.selectedSliceOrGroup!.coord); // fixme..
      } else {
        selectedSlice = null;
        selectedGroup = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          children: [
            Text('Image size:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.imageWidth} x ${widget.tileSet.imageHeight}'),
          ],
        ),
        Row(
          children: [
            Text('Tile size:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.tileWidth} x ${widget.tileSet.tileHeight}'),
          ],
        ),
        Row(
          children: [
            Text('Max tile:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.getMaxTileColumn()} x ${widget.tileSet.getMaxTileRow()}'),
          ],
        ),
        Row(
          children: [
            Text('Number of slices:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.slices.length}'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Number of groups:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.groups.length}'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Number of garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.garbage.indices.length}'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Number of selected free tile(s):', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('$numberOfSelectedFreeTiles'),
          ],
        ),
        Row(
          children: [
            Text('Number of selected garbage tile(s):', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('$numberOfSelectedGarbageTiles'),
          ],
        ),
        Row(
          children: [
            Text('Selected named area:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text(selectedSlice != null ? '$selectedSlice' : (selectedGroup != null ? '$selectedGroup' : '-')),
          ],
        ),
      ],
    );
  }
}

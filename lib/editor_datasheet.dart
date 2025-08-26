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
  TileSetSlice? selectedSlice;
  TileSetGroup? selectedGroup;

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
            Text('Tiles:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.getMaxTileColumn()} x ${widget.tileSet.getMaxTileRow()} (0..${widget.tileSet.getMaxTileIndex()})'),
          ],
        ),
        Row(
          children: [
            Text('Slices:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.slices.length}'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Groups:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.groups.length}'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.garbage.tileIndices.length}'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Selected named area:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Expanded(child: Text(selectedSlice != null ? '$selectedSlice' : (selectedGroup != null ? '$selectedGroup' : '-'))),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_info.dart';
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
  String? selectedTileDetails;
  int numberOfSelectedFreeTiles = 0;
  int numberOfSelectedGarbageTiles = 0;
  TileSetSlice? selectedSlice;
  TileSetGroup? selectedGroup;

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
      selectedTileDetails = tileInfo.toString();
      numberOfSelectedFreeTiles = state.selectedFreeTiles.length;
      numberOfSelectedGarbageTiles = state.selectedGarbageTiles.length;
      selectedSlice = widget.tileSet.findSlice(tileInfo.coord); // fixme..
      selectedGroup = widget.tileSet.findGroup(tileInfo.coord); // fixme..
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
            Text('${widget.tileSet.slices.length}'),
          ],
        ),
        Row(
          children: [
            Text('Number of groups:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.groups.length}'),
          ],
        ),
        Row(
          children: [
            Text('Number of garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.garbage.indices.length}'),
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
        Row(
          children: [
            Text('Last:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text(selectedTileDetails != null ? '$selectedTileDetails' : '-'),
          ],
        ),
      ],
    );
  }
}

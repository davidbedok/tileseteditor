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

  TileSetSlice currentSlice = TileSetSlice.none;
  TileSetGroup currentGroup = TileSetGroup.none;

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
    if (tileInfo.key != null) {
      if (state.selectedSlice != null) {
        TileSetSlice? slice = widget.tileSet.findSliceByKey(tileInfo.key!);
        setState(() {
          if (slice != null) {
            currentSlice = slice;
            currentGroup = TileSetGroup.none;
          } else {
            currentSlice = TileSetSlice.none;
          }
        });
      } else {
        setState(() {
          currentSlice = TileSetSlice.none;
        });
      }
      if (state.selectedGroup != null) {
        TileSetGroup? group = widget.tileSet.findGroupByKey(tileInfo.key!);
        setState(() {
          if (group != null) {
            currentGroup = group;
            currentSlice = TileSetSlice.none;
          } else {
            currentGroup = TileSetGroup.none;
          }
        });
      } else {
        setState(() {
          currentGroup = TileSetGroup.none;
        });
      }
    }
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
            Text('${widget.tileSet.getMaxTileColumn()} x ${widget.tileSet.getMaxTileRow()} (${widget.tileSet.getMaxTileIndex() + 1} tiles)'),
          ],
        ),
        Row(
          children: [
            Text('Garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${widget.tileSet.garbage.tileIndices.length} tile(s)'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Slices (${widget.tileSet.slices.length}):', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: const Color.fromARGB(255, 203, 216, 227),
                  scaffoldBackgroundColor: null,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
                child: DropdownButton<TileSetSlice>(
                  value: currentSlice,
                  style: Theme.of(context).textTheme.bodyMedium,
                  isExpanded: true,
                  items: widget.tileSet.getSlicesWithNone().map((TileSetSlice slice) {
                    return DropdownMenuItem<TileSetSlice>(value: slice, child: Text(slice.toDropDownValue()));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentSlice = value;
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
        Row(
          children: [
            Text('Groups (${widget.tileSet.groups.length}):', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: const Color.fromARGB(255, 198, 209, 129),
                  scaffoldBackgroundColor: null,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                ),
                child: DropdownButton<TileSetGroup>(
                  value: currentGroup,
                  style: Theme.of(context).textTheme.bodyMedium,
                  isExpanded: true,
                  items: widget.tileSet.getGroupsWithNone().map((TileSetGroup group) {
                    return DropdownMenuItem<TileSetGroup>(value: group, child: Text(group.toDropDownValue()));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentGroup = value;
                      });
                    }
                  },
                ),
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      ],
    );
  }
}

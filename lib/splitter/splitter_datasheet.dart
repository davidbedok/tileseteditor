import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_change_type.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/splitter/state/splitter_editor_state.dart';

class SplitterDatasheet extends StatefulWidget {
  final SplitterEditorState editorState;
  final TileSet tileSet;

  const SplitterDatasheet({super.key, required this.editorState, required this.tileSet});

  @override
  State<SplitterDatasheet> createState() => SplitterDatasheetState();
}

class SplitterDatasheetState extends State<SplitterDatasheet> {
  late TileSet tileSet;
  TileSetSlice? selectedSlice;
  TileSetGroup? selectedGroup;

  TileSetSlice currentSlice = TileSetSlice.none;
  TileSetGroup currentGroup = TileSetGroup.none;

  @override
  void initState() {
    super.initState();
    tileSet = widget.tileSet;
    widget.editorState.subscribeOnSelected(selectTile);
    widget.tileSet.subscribeOnChanged(changeTileSet);
  }

  @override
  void dispose() {
    widget.editorState.unsubscribeOnSelected(selectTile);
    widget.tileSet.unsubscribeOnChanged(changeTileSet);
    super.dispose();
  }

  void changeTileSet(TileSet tileSet, TileSetChangeType type) {
    setState(() {
      this.tileSet = tileSet;
      currentSlice = TileSetSlice.none;
      currentGroup = TileSetGroup.none;
    });
  }

  void selectTile(SplitterEditorState state, TileInfo tileInfo) {
    if (tileInfo.key != null) {
      if (state.selectedSliceInfo != null) {
        TileSetSlice? slice = tileSet.findSliceByKey(tileInfo.key!);
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
      if (state.selectedGroupInfo != null) {
        TileSetGroup? group = tileSet.findGroupByKey(tileInfo.key!);
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
            Text('${tileSet.imageWidth} x ${tileSet.imageHeight}'),
          ],
        ),
        Row(
          children: [
            Text('Tile size:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${tileSet.tileWidth} x ${tileSet.tileHeight}'),
          ],
        ),
        Row(
          children: [
            Text('Tiles:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${tileSet.getMaxTileColumn()} x ${tileSet.getMaxTileRow()} (${tileSet.getMaxTileIndex() + 1} tiles)'),
          ],
        ),
        Row(
          children: [
            Text('Garbages:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${tileSet.garbage.tileIndices.length} tile(s)'), // fixme: from state..
          ],
        ),
        Row(
          children: [
            Text('Slices (${tileSet.slices.length}):', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: const Color.fromARGB(255, 203, 216, 227),
                  scaffoldBackgroundColor: null,
                  hoverColor: Colors.transparent,
                  focusColor: Theme.of(context).canvasColor,
                ),
                child: DropdownButton<TileSetSlice>(
                  value: currentSlice,
                  style: Theme.of(context).textTheme.bodyMedium,
                  isExpanded: true,
                  items: tileSet.getSlicesWithNone().map((TileSetSlice slice) {
                    return DropdownMenuItem<TileSetSlice>(value: slice, child: Text(slice.toDropDownValue()));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null && currentSlice.key != value.key) {
                      setState(() {
                        currentSlice = value;
                      });
                      widget.editorState.selectSlice(currentSlice);
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
            Text('Groups (${tileSet.groups.length}):', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  items: tileSet.getGroupsWithNone().map((TileSetGroup group) {
                    return DropdownMenuItem<TileSetGroup>(value: group, child: Text(group.toDropDownValue()));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null && currentGroup.key != value.key) {
                      setState(() {
                        currentGroup = value;
                      });
                      widget.editorState.selectGroup(tileSet, currentGroup);
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

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/tileset/tileset_change_type.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/splitter/splitter_state.dart';

class SplitterDatasheet extends StatefulWidget {
  final SplitterState editorState;
  final TileSet tileSet;

  const SplitterDatasheet({super.key, required this.editorState, required this.tileSet});

  @override
  State<SplitterDatasheet> createState() => SplitterDatasheetState();
}

class SplitterDatasheetState extends State<SplitterDatasheet> {
  late TileSet tileSet;
  late TileSetItem tileSetItem;

  @override
  void initState() {
    super.initState();
    tileSet = widget.tileSet;
    tileSetItem = widget.editorState.tileSetItem;
    widget.editorState.subscribeSelection(selectTile);
    widget.tileSet.subscribeOnChanged(changeTileSet);
  }

  @override
  void dispose() {
    widget.editorState.unsubscribeSelection(selectTile);
    widget.tileSet.unsubscribeOnChanged(changeTileSet);
    super.dispose();
  }

  void changeTileSet(TileSet tileSet, TileSetChangeType type) {
    setState(() {
      this.tileSet = tileSet;
    });
  }

  void selectTile(SplitterState state, TileSetItem tileSetItem) {
    setState(() {
      this.tileSetItem = tileSetItem;
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
            Text('${tileSet.imageWidth} x ${tileSet.imageHeight}'),
          ],
        ),
        Row(
          children: [
            Text('Tile size:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 5),
            Text('${tileSet.tileSize.widthPx} x ${tileSet.tileSize.heightPx}'),
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
                  value: tileSetItem is TileSetSlice ? tileSetItem as TileSetSlice : TileSetSlice.none,
                  style: Theme.of(context).textTheme.bodyMedium,
                  isExpanded: true,
                  items: tileSet.getSlicesWithNone().map((TileSetSlice slice) {
                    return DropdownMenuItem<TileSetSlice>(value: slice, child: Text(slice.toDropDownValue()));
                  }).toList(),
                  onChanged: (TileSetSlice? value) {
                    if (value != null && tileSetItem.id != value.id) {
                      setState(() {
                        tileSetItem = value;
                      });
                      widget.editorState.selectTileSetItem(tileSetItem);
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
                  value: tileSetItem is TileSetGroup ? tileSetItem as TileSetGroup : TileSetGroup.none,
                  style: Theme.of(context).textTheme.bodyMedium,
                  isExpanded: true,
                  items: tileSet.getGroupsWithNone().map((TileSetGroup group) {
                    return DropdownMenuItem<TileSetGroup>(value: group, child: Text(group.toDropDownValue()));
                  }).toList(),
                  onChanged: (TileSetGroup? value) {
                    if (value != null && tileSetItem.id != value.id) {
                      setState(() {
                        tileSetItem = value;
                      });
                      widget.editorState.selectTileSetItem(tileSetItem);
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

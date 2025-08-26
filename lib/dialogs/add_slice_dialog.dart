import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/named_area_size.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/widgets/app_dialog_widget.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/widgets/slice_widget.dart';

class AddSliceDialog extends StatefulWidget {
  final TileSetProject project;
  final TileSet tileSet;
  final List<TileCoord> tiles;

  const AddSliceDialog({super.key, required this.project, required this.tileSet, required this.tiles});

  @override
  AddSliceDialogState createState() => AddSliceDialogState();
}

class AddSliceDialogState extends State<AddSliceDialog> {
  static final double space = 8.0;
  final _formKey = GlobalKey<FormState>();

  late TileSetSlice _slice;
  int numberOfNonFreeTiles = 0;

  @override
  void initState() {
    super.initState();
    int minX = widget.tiles.map((coord) => coord.x).reduce(min);
    int minY = widget.tiles.map((coord) => coord.y).reduce(min);
    int maxX = widget.tiles.map((coord) => coord.x).reduce(max);
    int maxY = widget.tiles.map((coord) => coord.y).reduce(max);
    _slice = TileSetSlice(widget.tileSet.getNextKey(), '', NamedAreaSize(maxX - minX + 1, maxY - minY + 1), minX, minY);
    for (int y = minY; y <= maxY; y++) {
      for (int x = minX; x <= maxX; x++) {
        TileCoord coord = TileCoord(x, y);
        TileInfo tileInfo = widget.tileSet.getTileInfo(coord);
        if (tileInfo.type != TileType.free) {
          numberOfNonFreeTiles++;
        }
        _slice.tileIndices.add(widget.tileSet.getIndex(coord));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppDialogWidget(
      formKey: _formKey,
      title: 'Add Slice',
      enabled: numberOfNonFreeTiles == 0,
      actionButton: 'Add',
      onAction: () {
        Navigator.of(context).pop(_slice);
      },
      children: [
        SliceWidget(
          slice: _slice, //
          project: widget.project,
          tileSet: widget.tileSet,
          numberOfNonFreeTiles: numberOfNonFreeTiles,
        ),
      ],
    );
  }
}

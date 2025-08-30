import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';

class SliceComponent extends TileSetComponent {
  TileSetSlice slice;

  @override
  TileSetItem getTileSetItem() => slice;

  SliceComponent({
    required super.position,
    required super.tileSetImage, //
    required super.originalPosition,
    required super.tileWidth,
    required super.tileHeight,
    required this.slice,
  }) : super(areaSize: slice.size);

  @override
  void releaseOutputData() => slice.output = null;

  @override
  void placeOutput(OutputTileComponent topLeftTile) => slice.output = topLeftTile.getCoord();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      tileSetImage, //
      srcPosition: Vector2((slice.left - 1) * tileWidth, (slice.top - 1) * tileHeight),
      srcSize: Vector2(slice.size.width * tileWidth, slice.size.height * tileHeight),
    );
    size = Vector2(slice.size.width * tileWidth, slice.size.height * tileHeight);
    // debugMode = true;
  }

  @override
  void drawInfo(dui.Canvas canvas) {
    var textSpan = TextSpan(
      text: slice.name,
      style: TextStyle(color: Color.fromARGB(255, 247, 224, 19), fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 200);
    textPainter.paint(canvas, Offset(0, -20));
  }
}

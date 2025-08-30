import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_tile.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';

class SingleTileComponent extends TileSetComponent {
  TileSetTile tile;

  int atlasX;
  int atlasY;

  @override
  TileSetItem getTileSetItem() => tile;

  SingleTileComponent({
    required super.position,
    required super.tileSetImage,
    required super.originalPosition,
    required super.tileWidth,
    required super.tileHeight,
    required this.tile,
    required this.atlasX,
    required this.atlasY,
  }) : super(areaSize: TileSetAreaSize(1, 1));

  @override
  void releaseOutputData() {
    tile.output = null;
  }

  @override
  void placeOutput(OutputTileComponent topLeftTile) {
    tile.output = topLeftTile.getCoord();
    game.tileSet.addTile(tile);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(tileSetImage, srcPosition: Vector2(atlasX * tileWidth, atlasY * tileHeight), srcSize: Vector2(tileWidth, tileHeight));
    size = Vector2(tileWidth, tileHeight);
    // debugMode = true;
  }

  @override
  void drawInfo(dui.Canvas canvas) {
    TileCoord coord = TileCoord(atlasX + 1, atlasY + 1);
    var textSpan = TextSpan(
      text: '${game.tileSet.getIndex(coord)} [${coord.toString()}]',
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 200);
    textPainter.paint(canvas, Offset(0, -20));
  }
}

import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';

class OutputTileComponent extends PositionComponent with HasGameReference<OutputEditorGame>, HoverCallbacks {
  double tileWidth;
  double tileHeight;
  dui.Image tileSetImage;

  int atlasX;
  int atlasY;

  TileSetComponent? storedTile;

  TileCoord getCoord() => TileCoord(atlasX + 1, atlasY + 1);

  OutputTileComponent({
    required this.tileSetImage,
    required this.tileWidth,
    required this.tileHeight,
    required this.atlasX,
    required this.atlasY,
    required super.position,
  }) {
    priority = 0;
  }

  bool canAccept(TileSetComponent tile) => isFree() || tile == storedTile;

  bool isFree() => storedTile == null;
  bool isUsed() => storedTile != null;

  void store(TileSetComponent tile) {
    storedTile = tile;
    tile.reservedTiles.add(this);
  }

  void empty() {
    storedTile = null;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(tileWidth, tileHeight);
    // debugMode = true;
  }

  static Paint getStandardPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  static Paint getSelectionPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  @override
  void update(double dt) {
    if (isHovered) {
      priority = 100;
    } else {
      priority = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(Rect.fromLTWH(0, 0, tileWidth, tileHeight), getStandardPaint(const dui.Color.fromARGB(255, 182, 182, 193), 1.0));

    if (isHovered) {
      canvas.drawRect(Rect.fromLTWH(0, 0, tileWidth, tileHeight), getSelectionPaint(const dui.Color.fromARGB(255, 29, 16, 215), 2.0));
      drawInfo(canvas);
    }
  }

  void drawInfo(dui.Canvas canvas) {
    TileCoord coord = getCoord();
    var textSpan = TextSpan(
      text: '${game.tileSet.getIndex(coord)} [${coord.toString()}]',
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 200);
    textPainter.paint(canvas, Offset(0, -20));
  }
}

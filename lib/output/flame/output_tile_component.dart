import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class OutputTileComponent extends PositionComponent with HasGameReference<OutputEditorGame>, HoverCallbacks {
  static const dui.Color standardColor = dui.Color.fromARGB(255, 182, 182, 193);
  static const dui.Color hoveredColor = dui.Color.fromARGB(255, 29, 16, 215);
  static const dui.Color textColor = dui.Color.fromARGB(255, 14, 110, 199);

  double tileWidth;
  double tileHeight;

  int atlasX;
  int atlasY;

  TileSetComponent? _storedTile;

  TileCoord getCoord() => TileCoord(atlasX + 1, atlasY + 1);
  bool canAccept(TileSetComponent tile) => isFree() || tile == _storedTile;
  bool isFree() => _storedTile == null;
  bool isUsed() => _storedTile != null;
  Rect getRect() => Rect.fromLTWH(0, 0, tileWidth, tileHeight);

  OutputTileComponent({
    required this.tileWidth, //
    required this.tileHeight,
    required this.atlasX,
    required this.atlasY,
    required super.position,
  }) {
    priority = 0;
  }

  void store(TileSetComponent tile) {
    _storedTile = tile;
    tile.reservedTiles.add(this);
  }

  void empty() {
    _storedTile = null;
  }

  void removeStoredTileSetItem() {
    if (_storedTile != null) {
      _storedTile!.removeFromOutput();
    }
    empty();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(tileWidth, tileHeight);
    // debugMode = true;
  }

  @override
  void update(double dt) {
    if (isHovered) {
      priority = 200;
    } else {
      priority = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(getRect(), DrawUtils.getBorderPaint(standardColor, 1.0));

    if (isHovered) {
      canvas.drawRect(getRect(), DrawUtils.getBorderPaint(hoveredColor, 2.0));
      drawInfo(canvas);
    }
  }

  void drawInfo(dui.Canvas canvas) {
    TileCoord coord = getCoord();
    var textSpan = TextSpan(
      text: '${game.tileSet.getIndex(coord)} [${coord.toString()}]',
      style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 200);
    textPainter.paint(canvas, Offset(0, tileHeight));
  }
}

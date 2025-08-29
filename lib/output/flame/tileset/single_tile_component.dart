import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/output/flame/tileset/output_component.dart';

class SingleTileComponent extends OutputComponent {
  double tileWidth;
  double tileHeight;
  dui.Image tileSetImage;

  int atlasX;
  int atlasY;

  SingleTileComponent({
    required this.tileSetImage,
    required this.tileWidth,
    required this.tileHeight,
    required this.atlasX,
    required this.atlasY,
    required super.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(tileSetImage, srcPosition: Vector2(atlasX * tileWidth, atlasY * tileHeight), srcSize: Vector2(tileWidth, tileHeight));
    size = Vector2(tileWidth, tileHeight);
    // debugMode = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isHovered) {
      canvas.drawRect(Rect.fromLTWH(0, 0, tileWidth, tileHeight), OutputComponent.getSelectionPaint(const dui.Color.fromARGB(255, 29, 16, 215), 2.0));
      drawInfo(canvas);
    }
  }

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

import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/splitter/flame/editor_game.dart';

class TileComponent extends SpriteComponent with HasGameReference<EditorGame>, TapCallbacks, HoverCallbacks {
  double tileWidth;
  double tileHeight;
  dui.Image tileSetImage;

  int atlasX;
  int atlasY;

  // TileInfo info;

  TileComponent({
    required this.tileSetImage,
    required this.tileWidth,
    required this.tileHeight,
    required this.atlasX,
    required this.atlasY,
    required super.position,
    // required this.info,
  }) {
    priority = 0;
  }

  bool isSelected() => game.splitterState.isSelected(getInfo());

  TileInfo getInfo() => game.tileSet.getTileInfo(TileCoord(atlasX + 1, atlasY + 1));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(tileSetImage, srcPosition: Vector2(atlasX * tileWidth, atlasY * tileHeight), srcSize: Vector2(tileWidth, tileHeight));
    size = Vector2(tileWidth, tileHeight);
    // debugMode = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.splitterState.selectTile(getInfo());
  }

  static Paint getSlicePaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  static Paint getSlicePaint2(Color color) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  static Paint getSelectionPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  static Paint getGarbagePaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
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
    TileInfo info = getInfo();
    switch (info.type) {
      case TileType.free:
        if (isSelected()) {
          canvas.drawRect(Rect.fromLTWH(1, 1, tileWidth - 2, tileHeight - 2), getSelectionPaint(Colors.blue, 2.0));
        }
      case TileType.slice:
        // canvas.drawRect(Rect.fromLTWH(1, 1, spriteWidth - 2, spriteHeight - 2), getSlicePaint(info.color!, 2));
        canvas.drawRect(Rect.fromLTWH(0, 0, tileWidth, tileHeight), getSlicePaint2(info.color!.withAlpha(100)));
        if (isSelected()) {
          canvas.drawOval(Rect.fromLTWH(4, 4, tileWidth - 8, tileHeight - 8), getSlicePaint2(info.color!.withAlpha(150)));
        }
      case TileType.group:
        // canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(2, 2, spriteWidth - 4, spriteHeight - 4), Radius.circular(6)), getSlicePaint(info.color!, 4.0));
        canvas.drawRect(Rect.fromLTWH(1, 1, tileWidth - 2, tileHeight - 2), getSlicePaint(info.color!, 2.0));

        if (isSelected()) {
          canvas.drawOval(Rect.fromLTWH(4, 4, tileWidth - 8, tileHeight - 8), getSlicePaint2(info.color!.withAlpha(150)));
        }
      case TileType.garbage:
        if (isSelected()) {
          canvas.drawLine(Offset(4, 4), Offset(tileWidth - 4, tileHeight - 4), getGarbagePaint(Colors.green, 2));
          canvas.drawLine(Offset(4, tileHeight - 4), Offset(tileWidth - 4, 4), getGarbagePaint(Colors.green, 2));
        } else {
          canvas.drawLine(Offset(4, 4), Offset(tileWidth - 4, tileHeight - 4), getGarbagePaint(Colors.red, 2));
          canvas.drawLine(Offset(4, tileHeight - 4), Offset(tileWidth - 4, 4), getGarbagePaint(Colors.red, 2));
        }
    }
    if (isHovered) {
      canvas.drawRect(Rect.fromLTWH(0, 0, tileWidth, tileHeight), getSelectionPaint(const dui.Color.fromARGB(255, 29, 16, 215), 2.0));

      drawInfo(info, canvas);
      drawCoord(info, canvas);
    }
  }

  void drawInfo(TileInfo info, dui.Canvas canvas) {
    var textSpan = TextSpan(
      text: info.getHoverText(),
      style: TextStyle(color: info.getHoverColor(), fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 200);
    textPainter.paint(canvas, Offset(0, -20));
  }

  void drawCoord(TileInfo info, dui.Canvas canvas) {
    var textSpan = TextSpan(
      text: '${game.tileSet.getIndex(info.coord)} [${info.coord.toString()}]',
      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 100);
    textPainter.paint(canvas, Offset(0, height));
  }
}

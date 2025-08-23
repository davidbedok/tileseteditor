import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/flame/editor_game.dart';

class TileComponent extends SpriteComponent with HasGameReference<EditorGame>, TapCallbacks {
  double spriteWidth;
  double spriteHeight;
  dui.Image tileSetImage;

  int atlasX;
  int atlasY;

  bool selected = false;
  TileInfo info;

  TileComponent({
    required this.tileSetImage,
    required this.spriteWidth,
    required this.spriteHeight,
    required this.atlasX,
    required this.atlasY,
    required super.position,
    required this.info,
    required this.selected,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(tileSetImage, srcPosition: Vector2(atlasX * spriteWidth, atlasY * spriteHeight), srcSize: Vector2(spriteWidth, spriteHeight));
    size = Vector2(spriteWidth, spriteHeight);
    // debugMode = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (info.type == TileType.free || info.type == TileType.garbage) {
      selected = !selected;
    }
    game.onSelectTile.call(selected, info);
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
  void render(Canvas canvas) {
    super.render(canvas);
    switch (info.type) {
      case TileType.free:
        if (selected) {
          canvas.drawRect(Rect.fromLTWH(0, 0, spriteWidth, spriteHeight), getSelectionPaint(Colors.blue, 2.0));
        }
      case TileType.slice:
        canvas.drawRect(Rect.fromLTWH(1, 1, spriteWidth - 2, spriteHeight - 2), getSlicePaint(info.color!, 2));
        canvas.drawRect(Rect.fromLTWH(0, 0, spriteWidth, spriteHeight), getSlicePaint2(info.color!.withAlpha(100)));
        if (selected) {
          canvas.drawOval(Rect.fromLTWH(4, 4, spriteWidth - 8, spriteHeight - 8), getSlicePaint2(info.color!.withAlpha(150)));
        }
      case TileType.group:
        canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(2, 2, spriteWidth - 4, spriteHeight - 4), Radius.circular(6)), getSlicePaint(info.color!, 4.0));

        if (selected) {
          canvas.drawOval(Rect.fromLTWH(4, 4, spriteWidth - 8, spriteHeight - 8), getSlicePaint2(info.color!.withAlpha(150)));
        }
      case TileType.garbage:
        if (selected) {
          canvas.drawLine(Offset(4, 4), Offset(spriteWidth - 4, spriteHeight - 4), getGarbagePaint(Colors.green, 2));
          canvas.drawLine(Offset(4, spriteHeight - 4), Offset(spriteWidth - 4, 4), getGarbagePaint(Colors.green, 2));
        } else {
          canvas.drawLine(Offset(4, 4), Offset(spriteWidth - 4, spriteHeight - 4), getGarbagePaint(Colors.red, 2));
          canvas.drawLine(Offset(4, spriteHeight - 4), Offset(spriteWidth - 4, 4), getGarbagePaint(Colors.red, 2));
        }
    }
  }
}

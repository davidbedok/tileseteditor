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
    if (info.type == TileType.free) {
      selected = !selected;
      game.onSelectTile.call(selected, TileCoord(atlasX + 1, atlasY + 1));
    }
  }

  static Paint getBorderPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (info.type) {
      case TileType.free:
        if (selected) {
          canvas.drawRect(Rect.fromLTWH(0, 0, spriteWidth, spriteHeight), getBorderPaint(Colors.blue, 2.0));
        }
      case TileType.slice:
        canvas.drawRect(Rect.fromLTWH(0, 0, spriteWidth, spriteHeight), getBorderPaint(Colors.yellow, 4.0));
      case TileType.group:
        // TODO: Handle this case.
        throw UnimplementedError();
      case TileType.garbage:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}

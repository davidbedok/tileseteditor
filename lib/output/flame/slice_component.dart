import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';

class SliceComponent extends SpriteComponent with HasGameReference<OutputEditorGame>, DragCallbacks, TapCallbacks, HoverCallbacks {
  TileSetSlice slice;
  double tileWidth;
  double tileHeight;
  dui.Image tileSetImage;

  SliceComponent({required this.tileSetImage, required this.slice, required this.tileWidth, required this.tileHeight, required super.position}) {
    priority = 0;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      tileSetImage,
      srcPosition: Vector2((slice.left - 1) * tileWidth, (slice.top - 1) * tileHeight),
      srcSize: Vector2(slice.size.width * tileWidth, slice.size.height * tileHeight),
    );
    size = Vector2(slice.size.width * tileWidth, slice.size.height * tileHeight);
    // debugMode = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    //
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

    if (isHovered) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, slice.size.width * tileWidth, slice.size.height * tileHeight),
        getSelectionPaint(const dui.Color.fromARGB(255, 29, 16, 215), 2.0),
      );
      drawInfo(canvas);
    }
  }

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

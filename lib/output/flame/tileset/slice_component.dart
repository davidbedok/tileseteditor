import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';

class SliceComponent extends TileSetComponent {
  TileSetSlice slice;
  dui.Image tileSetImage;

  SliceComponent({
    required this.tileSetImage, //
    required this.slice,
    required super.tileWidth,
    required super.tileHeight,
    required super.position,
  }) : super(areaSize: slice.size);

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

import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';

class GroupComponent extends TileSetComponent {
  TileSetGroup group;
  dui.Image tileSetImage;

  GroupComponent({
    required this.tileSetImage, //
    required this.group,
    required super.tileWidth,
    required super.tileHeight,
    required super.position,
  }) : super(areaSize: group.size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    ImageComposition composition = ImageComposition();

    List<Sprite> sprites = [];

    int tileIndex = 0;
    for (int j = 0; j < group.size.height; j++) {
      for (int i = 0; i < group.size.width; i++) {
        if (tileIndex < group.tileIndices.length) {
          int index = group.tileIndices[tileIndex];
          TileCoord tileCoord = game.tileSet.getTileCoord(index);
          Sprite tmpSprite = Sprite(
            tileSetImage,
            srcPosition: Vector2((tileCoord.x - 1) * tileWidth, (tileCoord.y - 1) * tileHeight),
            srcSize: Vector2(tileWidth, tileHeight),
          );

          composition.add(tmpSprite.toImageSync(), Vector2(i * tileWidth.toDouble(), j * tileHeight.toDouble()));
          sprites.add(tmpSprite);
          tileIndex++;
        }
      }
    }

    dui.Image compositeImage = await composition.compose();
    sprite = Sprite(
      compositeImage, //
      srcPosition: Vector2(0, 0),
      srcSize: Vector2(group.size.width * tileWidth, group.size.height * tileHeight),
    );
    size = Vector2(group.size.width * tileWidth, group.size.height * tileHeight);

    // debugMode = true;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (isHovered) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, group.size.width * tileWidth, group.size.height * tileHeight),
        TileSetComponent.getSelectionPaint(const dui.Color.fromARGB(255, 29, 16, 215), 2.0),
      );
      drawInfo(canvas);
    }
  }

  void drawInfo(dui.Canvas canvas) {
    var textSpan = TextSpan(
      text: group.name,
      style: TextStyle(color: Color.fromARGB(255, 171, 33, 178), fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 200);
    textPainter.paint(canvas, Offset(0, -20));
  }
}

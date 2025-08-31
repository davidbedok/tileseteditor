import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/splitter/flame/editor_game.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class TileComponent extends SpriteComponent with HasGameReference<EditorGame>, TapCallbacks, HoverCallbacks {
  TileSet tileSet;

  int atlasX;
  int atlasY;

  double tileWidth;
  double tileHeight;

  TileCoord getCoord() => TileCoord(atlasX + 1, atlasY + 1);
  Vector2 getRealSize() => Vector2(tileWidth, tileHeight);
  Vector2 getRealPosition() => Vector2(atlasX * tileWidth, atlasY * tileHeight);
  bool isSelected() => game.splitterState.isSelected(getInfo());
  TileInfo getInfo() => tileSet.getTileInfo(getCoord());
  Rect getRect(double innerPadding) => Rect.fromLTWH(innerPadding, innerPadding, tileWidth - innerPadding * 2, tileHeight - innerPadding * 2);

  TileComponent({
    required this.tileSet, //
    required this.atlasX,
    required this.atlasY,
    required super.position,
  }) : tileWidth = tileSet.tileWidth.toDouble(),
       tileHeight = tileSet.tileHeight.toDouble() {
    priority = 0;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      tileSet.image!, //
      srcPosition: getRealPosition(),
      srcSize: getRealSize(),
    );
    size = getRealSize();
    // debugMode = true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.splitterState.selectTile(getInfo());
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
          canvas.drawRect(getRect(1), DrawUtils.getBorderPaint(EditorColor.free.color, 2.0));
        }
      case TileType.slice:
        canvas.drawRect(getRect(0), DrawUtils.getFillPaint(info.color!, alpha: 100));
        if (isSelected()) {
          canvas.drawOval(getRect(4), DrawUtils.getFillPaint(info.color!, alpha: 150));
        }
      case TileType.group:
        canvas.drawRect(getRect(1), DrawUtils.getBorderPaint(info.color!, 2.0));

        if (isSelected()) {
          canvas.drawOval(getRect(4), DrawUtils.getFillPaint(info.color!, alpha: 150));
        }
      case TileType.garbage:
        if (isSelected()) {
          drawGarbage(canvas, EditorColor.garbageSelected.color);
        } else {
          drawGarbage(canvas, EditorColor.garbage.color);
        }
    }
    if (isHovered) {
      canvas.drawRect(getRect(0), DrawUtils.getBorderPaint(EditorColor.hovered.color, 2.0));
      drawInfo(info, canvas);
      drawCoord(info, canvas);
    }
  }

  void drawGarbage(dui.Canvas canvas, Color color) {
    canvas.drawLine(Offset(4, 4), Offset(tileWidth - 4, tileHeight - 4), DrawUtils.getLinePaint(color, 2));
    canvas.drawLine(Offset(4, tileHeight - 4), Offset(tileWidth - 4, 4), DrawUtils.getLinePaint(color, 2));
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
      style: TextStyle(color: EditorColor.coordText.color, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 100);
    textPainter.paint(canvas, Offset(0, height));
  }
}

import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';
import 'package:tileseteditor/splitter/flame/splitter_game.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class TileComponent extends SpriteComponent with HasGameReference<SplitterGame>, TapCallbacks, HoverCallbacks {
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
  }) : tileWidth = tileSet.tileSize.widthPx.toDouble(),
       tileHeight = tileSet.tileSize.heightPx.toDouble() {
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
    Color hoverColor = EditorColor.tile.color;
    if (info.item == TileSetTile.freeTile) {
      if (isSelected()) {
        canvas.drawRect(getRect(1), DrawUtils.getBorderPaint(EditorColor.tile.color, 2.0));
      }
    } else if (info.item == TileSetTile.garbageTile) {
      hoverColor = EditorColor.garbage.color;
      if (isSelected()) {
        drawGarbage(canvas, EditorColor.garbageSelected.color);
      } else {
        drawGarbage(canvas, EditorColor.garbage.color);
      }
    } else if (info.item is TileSetSlice) {
      canvas.drawRect(getRect(0), DrawUtils.getFillPaint(info.item.getColor(), alpha: 100));
      hoverColor = EditorColor.slice.color;
      if (isSelected()) {
        drawSelectedSlice(info, canvas);
      }
    } else if (info.item is TileSetGroup) {
      canvas.drawRect(getRect(0), DrawUtils.getFillPaint(info.item.getColor(), alpha: 100));
      hoverColor = EditorColor.group.color;
      if (isSelected()) {
        canvas.drawRect(getRect(2), DrawUtils.getBorderPaint(EditorColor.group.color, 3.0));
      }
    }
    if (isHovered) {
      canvas.drawRect(getRect(0), DrawUtils.getBorderPaint(hoverColor, 2.0));
      if (info.item is TileSetSlice || info.item is TileSetGroup) {
        drawInfo(info, canvas, hoverColor);
      }
      drawCoord(info, canvas);
    }
  }

  void drawSelectedSlice(TileInfo info, dui.Canvas canvas) {
    TileSetSlice slice = info.item as TileSetSlice;
    double lineWidth = 4;
    double halfLw = lineWidth / 2;
    if (slice.coord.left == atlasX + 1) {
      canvas.drawLine(
        Offset(halfLw, halfLw),
        Offset(halfLw, tileHeight - halfLw),
        DrawUtils.getLinePaint(EditorColor.slice.color, lineWidth, strokeCap: StrokeCap.square),
      );
    }
    if (slice.coord.top == atlasY + 1) {
      canvas.drawLine(
        Offset(halfLw, halfLw),
        Offset(tileWidth - halfLw, halfLw),
        DrawUtils.getLinePaint(EditorColor.slice.color, lineWidth, strokeCap: StrokeCap.square),
      );
    }
    if (slice.coord.left + slice.size.width - 1 == atlasX + 1) {
      canvas.drawLine(
        Offset(tileWidth - halfLw, halfLw),
        Offset(tileWidth - halfLw, tileHeight - halfLw),
        DrawUtils.getLinePaint(EditorColor.slice.color, lineWidth, strokeCap: StrokeCap.square),
      );
    }
    if (slice.coord.top + slice.size.height - 1 == atlasY + 1) {
      canvas.drawLine(
        Offset(halfLw, tileHeight - halfLw),
        Offset(tileWidth - halfLw, tileHeight - halfLw),
        DrawUtils.getLinePaint(EditorColor.slice.color, lineWidth, strokeCap: StrokeCap.square),
      );
    }
  }

  void drawGarbage(dui.Canvas canvas, Color color) {
    canvas.drawLine(Offset(4, 4), Offset(tileWidth - 4, tileHeight - 4), DrawUtils.getLinePaint(color, 2));
    canvas.drawLine(Offset(4, tileHeight - 4), Offset(tileWidth - 4, 4), DrawUtils.getLinePaint(color, 2));
  }

  void drawInfo(TileInfo info, dui.Canvas canvas, Color color) {
    var textSpan = TextSpan(
      text: info.item.getLabel(),
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    double textPadding = 10;
    double textWidth = textPainter.size.width + textPadding * 2;
    double shiftX = (textWidth - tileWidth) / 2 * -1;
    canvas.drawRect(Rect.fromLTWH(shiftX, textPainter.size.height * -1, textWidth, textPainter.size.height), DrawUtils.getFillPaint(Colors.white, alpha: 150));

    textPainter.paint(canvas, Offset(shiftX + textPadding, textPainter.size.height * -1));
  }

  void drawCoord(TileInfo info, dui.Canvas canvas) {
    var textSpan = TextSpan(
      text: '${game.tileSet.getIndex(info.coord)} [${info.coord.toString()}]',
      style: TextStyle(color: EditorColor.coordText.color, fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    double textPadding = 10;
    double textWidth = textPainter.size.width + textPadding * 2;
    double shiftX = (textWidth - tileWidth) / 2 * -1;
    canvas.drawRect(Rect.fromLTWH(shiftX, height, textWidth, textPainter.size.height), DrawUtils.getFillPaint(Colors.white, alpha: 150));

    textPainter.paint(canvas, Offset(shiftX + textPadding, height));
  }
}

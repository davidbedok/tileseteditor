import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/component/yate_component.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class OutputTileComponent extends PositionComponent with HasGameReference<OutputEditorGame>, HoverCallbacks {
  double tileWidth;
  double tileHeight;

  int atlasX;
  int atlasY;

  YateComponent? _stored;

  TileCoord getCoord() => TileCoord(atlasX + 1, atlasY + 1);
  bool canAccept(YateComponent tile) => isFree() || tile == _stored;
  bool isFree() => _stored == null;
  bool isUsed() => _stored != null;
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

  void store(YateComponent component) {
    _stored = component;
    component.reservedTiles.add(this);
  }

  void empty() {
    _stored = null;
  }

  void removeStoredTileSetItem() {
    if (_stored != null) {
      _stored!.removeFromOutput();
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
    canvas.drawRect(getRect(), DrawUtils.getBorderPaint(EditorColor.grid.color, 1.0));
    if (isHovered) {
      drawCoord(canvas);
    }
  }

  void drawCoord(dui.Canvas canvas) {
    TileCoord coord = getCoord();
    var textSpan = TextSpan(
      text: '[${coord.toString()}]',
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

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';

abstract class TileSetNamedArea extends YateItem {
  String name;
  TileRectSize size;

  Color color = RandomColor.getColorObject(Options());

  @override
  Color getColor() => color;

  @override
  Vector2 getRealSize(double tileWidth, double tileHeight) => Vector2(size.width * tileWidth, size.height * tileHeight);

  @override
  String getLabel() => name;

  TileSetNamedArea({
    required super.id, //
    required this.name,
    required this.size,
  });

  String toDropDownValue() {
    String addon = '';
    if (id >= 0) {
      addon = ' ${size.toDropDownValue()} ($id)';
    }
    return '$name$addon';
  }
}

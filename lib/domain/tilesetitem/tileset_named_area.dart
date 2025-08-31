import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';

abstract class TileSetNamedArea extends TileSetItem {
  int key;
  String name;
  TileSetAreaSize size;

  Color color = RandomColor.getColorObject(Options());

  @override
  Vector2 getRealSize(double tileWidth, double tileHeight) => Vector2(size.width * tileWidth, size.height * tileHeight);

  @override
  String getButtonLabel() => name;

  TileSetNamedArea(this.key, this.name, this.size);

  String toDropDownValue() {
    String addon = '';
    if (key >= 0) {
      addon = ' ${size.toDropDownValue()} ($key)';
    }
    return '$name$addon';
  }
}

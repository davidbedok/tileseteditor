import 'dart:ui';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';

class TileSetNamedArea {
  int key;
  String name;
  List<int> tileIndices = [];
  TileSetAreaSize size;

  Color color = RandomColor.getColorObject(Options());

  TileSetNamedArea(this.key, this.name, this.size);

  String toDropDownValue() {
    String addon = '';
    if (key >= 0) {
      addon = ' ${size.toDropDownValue()} ($key)';
    }
    return '$name$addon';
  }
}

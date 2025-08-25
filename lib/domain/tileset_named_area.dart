import 'dart:ui';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:tileseteditor/domain/named_area_size.dart';

class TileSetNamedArea {
  int key;
  String name;
  List<int> tileIndices = [];
  NamedAreaSize size;

  Color color = RandomColor.getColorObject(Options());

  TileSetNamedArea(this.key, this.name, this.size);
}

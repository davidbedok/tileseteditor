import 'dart:ui';

import 'package:flutter_randomcolor/flutter_randomcolor.dart';

class TileSetNamedArea {
  int key;
  String name;
  List<int> tileIndices = [];

  Color color = RandomColor.getColorObject(Options());

  TileSetNamedArea(this.key, this.name);
}

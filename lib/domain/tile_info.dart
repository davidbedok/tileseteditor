import 'dart:ui';

import 'package:tileseteditor/domain/tile_type.dart';

class TileInfo {
  TileType type;
  String? name;
  Color? color;

  TileInfo({required this.type, this.name, this.color});
}

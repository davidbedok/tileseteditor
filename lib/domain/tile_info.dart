import 'dart:ui';

import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_type.dart';

class TileInfo {
  TileType type;
  TileCoord coord;
  String? name;
  Color? color;

  TileInfo({required this.type, required this.coord, this.name, this.color});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TileInfo &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          name ==
              other
                  .name /* &&
          coord.x == other.coord.x &&
          coord.y == other.coord.y */ );

  @override
  int get hashCode => name.hashCode;
}

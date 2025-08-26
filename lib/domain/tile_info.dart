import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_type.dart';

class TileInfo {
  TileType type;
  TileCoord coord;
  int? key;
  String? name;
  Color? color;

  TileInfo({required this.type, required this.coord, this.key, this.name, this.color});

  String getHoverText() {
    String result = '';
    switch (type) {
      case TileType.free:
        result = '';
      case TileType.slice:
      case TileType.group:
        result = '$name (${type.name})';
      case TileType.garbage:
        result = 'garbage';
    }
    return result;
  }

  Color getHoverColor() {
    switch (type) {
      case TileType.free:
        return Colors.black;
      case TileType.slice:
        return Color.fromARGB(255, 247, 224, 19);
      case TileType.group:
        return Color.fromARGB(255, 171, 33, 178);
      case TileType.garbage:
        return Color.fromARGB(255, 216, 21, 21);
    }
  }

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

  @override
  String toString() {
    return '${type.name} (coord: $coord)${name != null ? ' >> $name' : ''}';
  }
}

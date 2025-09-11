import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';

abstract class YateItem {
  static final YateItem none = TileSetTile(id: -1, coord: TileCoord(0, 0));

  int id;
  TileCoord? output;
  List<int> tileIndices = [];

  YateItem({required this.id});

  Color getColor();
  Color getHoverColor();
  Color getTextColor();
  String getLabel();
  Vector2 getRealSize(double tileWidth, double tileHeight);
  Vector2 getRealPosition(double tileWidth, double tileHeight);

  static TileCoord? outputFromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? output = json['output'] != null ? (json['output'] as Map<String, dynamic>) : null;
    return output != null ? TileCoord.fromJson(output) : null;
  }

  static List<int> tileIndicesFromJson(Map<String, dynamic> json) {
    List<int> result = [];
    List<int> tileIndices = json['indices'] != null ? (json['indices'] as List).map((index) => index as int).toList() : [];
    if (tileIndices.isNotEmpty) {
      result.addAll(tileIndices);
    }
    return result;
  }
}

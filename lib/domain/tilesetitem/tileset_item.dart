import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_tile.dart';

abstract class TileSetItem {
  static final TileSetItem none = TileSetTile(0, 0);

  TileCoord? output;
  List<int> tileIndices = [];

  Color getColor();
  Color getHoverColor();
  Color getTextColor();
  int getKey();
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

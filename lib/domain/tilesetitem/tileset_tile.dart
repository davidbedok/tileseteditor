import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';

class TileSetTile extends TileSetItem {
  int left;
  int top;

  @override
  String getButtonLabel() => 'Tile $left:$top';

  @override
  Color getTextColor() => EditorColor.tileSetTile.color;

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2((left - 1) * tileWidth, (top - 1) * tileHeight);

  @override
  Vector2 getRealSize(double tileWidth, double tileHeight) => Vector2(tileWidth, tileHeight);

  TileSetTile(this.left, this.top);

  Map<String, dynamic> toJson(TileSet tileSet) {
    tileIndices.clear();
    tileIndices.add(tileSet.getIndex(TileCoord(left, top)));
    return {
      'left': left, //
      'top': top, //
      'indices': tileIndices,
      'output': output?.toJson(),
    };
  }

  factory TileSetTile.fromJson(Map<String, dynamic> json) {
    TileSetTile result = switch (json) {
      {
        'left': int left, //
        'top': int top, //
      } =>
        TileSetTile(left, top),
      _ => throw const FormatException('Failed to load TileSetTile'),
    };
    result.tileIndices = TileSetItem.tileIndicesFromJson(json);
    result.output = TileSetItem.outputFromJson(json);
    return result;
  }

  static List<TileSetTile> tilesFromJson(Map<String, dynamic> json) {
    List<TileSetTile> result = [];
    List<Map<String, dynamic>> tiles = json['tiles'] != null ? (json['tiles'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var group in tiles) {
      result.add(TileSetTile.fromJson(group));
    }
    return result;
  }

  static List<Map<String, dynamic>> tilesToJson(TileSet tileSet, List<TileSetTile> tiles) {
    List<Map<String, dynamic>> result = [];
    for (var tile in tiles) {
      result.add(tile.toJson(tileSet));
    }
    return result;
  }
}

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';

class TileSetTile extends YateItem {
  static final TileSetTile freeTile = TileSetTile(id: -1, coord: TileCoord(0, 0));
  static final TileSetTile garbageTile = TileSetTile(id: -1, coord: TileCoord(0, 0), garbage: true);

  TileCoord coord;
  bool garbage = false;

  @override
  String getLabel() => 'Tile ${coord.left}:${coord.top}';

  @override
  Color getColor() => EditorColor.tileFreeHovered.color; // FIXME check this

  @override
  Color getHoverColor() => garbage ? EditorColor.tileGarbageHovered.color : EditorColor.tileFreeHovered.color;

  @override
  Color getTextColor() => EditorColor.tileSetTile.color;

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2((coord.left - 1) * tileWidth, (coord.top - 1) * tileHeight);

  @override
  Vector2 getRealSize(double tileWidth, double tileHeight) => Vector2(tileWidth, tileHeight);

  TileSetTile({
    required super.id, //
    required this.coord,
    bool garbage = false,
  });

  static List<Map<String, dynamic>> tilesToJson(TileSet tileSet, List<TileSetTile> tiles) {
    List<Map<String, dynamic>> result = [];
    for (var tile in tiles) {
      result.add(tile.toJson(tileSet));
    }
    return result;
  }

  Map<String, dynamic> toJson(TileSet tileSet) {
    tileIndices.clear();
    tileIndices.add(tileSet.getIndex(coord));
    return {
      'id': id, //
      'left': coord.left,
      'top': coord.top,
      'indices': tileIndices,
      'output': output?.toJson(),
    };
  }

  static List<TileSetTile> itemsFromJson(Map<String, dynamic> json) {
    List<TileSetTile> result = [];
    List<Map<String, dynamic>> tiles = json['tiles'] != null ? (json['tiles'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var group in tiles) {
      result.add(TileSetTile.fromJson(group));
    }
    return result;
  }

  factory TileSetTile.fromJson(Map<String, dynamic> json) {
    TileSetTile result = switch (json) {
      {
        'id': int id,
        'left': int left, //
        'top': int top, //
      } =>
        TileSetTile(id: id, coord: TileCoord(left, top)),
      _ => throw const FormatException('Failed to load TileSetTile'),
    };
    result.tileIndices = YateItem.tileIndicesFromJson(json);
    result.output = YateItem.outputFromJson(json);
    return result;
  }
}

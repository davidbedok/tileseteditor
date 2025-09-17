import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_named_area.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileSetSlice extends TileSetNamedArea implements YateMapper {
  static final TileSetSlice none = TileSetSlice(
    id: -1, //
    name: '-',
    size: TileRectSize(0, 0),
    coord: TileCoord(0, 0),
  );

  TileCoord coord;

  @override
  Color getHoverColor() => EditorColor.sliceText.color;

  @override
  Color getTextColor() => EditorColor.slice.color;

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2((coord.left - 1) * tileWidth, (coord.top - 1) * tileHeight);

  TileSetSlice({
    required super.id, //
    required super.name,
    required super.size,
    required this.coord,
  });

  bool isInnerCoord(TileCoord coord) {
    return coord.left >= this.coord.left &&
        coord.left < this.coord.left + size.width &&
        coord.top >= this.coord.top &&
        coord.top < this.coord.top + size.height;
  }

  @override
  Map<String, dynamic> toJson() {
    tileIndices.sort();
    return {
      'id': id, //
      'name': name, //
      'indices': tileIndices,
      'left': coord.left,
      'top': coord.top,
      'width': size.width,
      'height': size.height,
      'output': output?.toJson(),
    };
  }

  static List<TileSetSlice> itemsFromJson(TileSet tileSet, Map<String, dynamic> json) {
    List<TileSetSlice> result = [];
    List<Map<String, dynamic>> slices = json['slices'] != null ? (json['slices'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var slice in slices) {
      result.add(TileSetSlice.fromJson(tileSet, slice));
    }
    return result;
  }

  factory TileSetSlice.fromJson(TileSet tileSet, Map<String, dynamic> json) {
    TileSetSlice result = switch (json) {
      {
        'id': int id,
        'name': String name, //
        'left': int left, //
        'top': int top, //
        'width': int width, //
        'height': int height, //
      } =>
        TileSetSlice(
          id: id, //
          name: name,
          size: TileRectSize(width, height),
          coord: TileCoord(left, top),
        ),
      _ => throw const FormatException('Failed to load TileSetSlice'),
    };
    result.tileIndices = YateItem.tileIndicesFromJson(json);
    result.output = YateItem.outputFromJson(json);
    return result;
  }

  @override
  String toString() {
    return 'Slice $name (l:${coord.left} t:${coord.top} w:${size.width} h:${size.height})';
  }
}

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_named_area.dart';

class TileSetSlice extends TileSetNamedArea {
  static final TileSetSlice none = TileSetSlice(id: -1, name: '-', size: TileSetAreaSize(0, 0), left: 0, top: 0);

  int left;
  int top;

  @override
  Color getHoverColor() => EditorColor.tileSliceHovered.color;

  @override
  Color getTextColor() => EditorColor.tileSetSlice.color;

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2((left - 1) * tileWidth, (top - 1) * tileHeight);

  TileSetSlice({
    required super.id, //
    required super.name,
    required super.size,
    required this.left,
    required this.top,
  });

  bool isInnerCoord(TileCoord coord) {
    return coord.left >= left && coord.left < left + size.width && coord.top >= top && coord.top < top + size.height;
  }

  Map<String, dynamic> toJson() {
    tileIndices.sort();
    return {
      'id': id, //
      'name': name, //
      'indices': tileIndices,
      'left': left,
      'top': top,
      'width': size.width,
      'height': size.height,
      'output': output?.toJson(),
    };
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
        TileSetSlice(id: id, name: name, size: TileSetAreaSize(width, height), left: left, top: top),
      _ => throw const FormatException('Failed to load TileSetSlice'),
    };
    result.tileIndices = TileSetItem.tileIndicesFromJson(json);
    result.output = TileSetItem.outputFromJson(json);
    return result;
  }

  @override
  String toString() {
    return 'Slice $name (l:$left t:$top w:${size.width} h:${size.height})';
  }

  static List<TileSetSlice> slicesFromJson(TileSet tileSet, Map<String, dynamic> json) {
    List<TileSetSlice> result = [];
    List<Map<String, dynamic>> slices = json['slices'] != null ? (json['slices'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var slice in slices) {
      result.add(TileSetSlice.fromJson(tileSet, slice));
    }
    return result;
  }

  static List<Map<String, dynamic>> slicestoJson(List<TileSetSlice> slices) {
    List<Map<String, dynamic>> result = [];
    for (var slice in slices) {
      result.add(slice.toJson());
    }
    return result;
  }
}

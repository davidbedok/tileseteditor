import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_named_area.dart';

class TileSetSlice extends TileSetNamedArea {
  static final TileSetSlice none = TileSetSlice(-1, '-', TileSetAreaSize(0, 0), 0, 0);

  int left;
  int top;

  @override
  Color getTextColor() => Color.fromARGB(255, 247, 224, 19);

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2((left - 1) * tileWidth, (top - 1) * tileHeight);

  TileSetSlice(super.key, super.name, super.size, this.left, this.top);

  bool isInnerCoord(TileCoord coord) {
    return coord.left >= left && coord.left < left + size.width && coord.top >= top && coord.top < top + size.height;
  }

  Map<String, dynamic> toJson() {
    tileIndices.sort();
    return {
      'key': key, //
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
        'key': int key, //
        'name': String name, //
        'left': int left, //
        'top': int top, //
        'width': int width, //
        'height': int height, //
      } =>
        TileSetSlice(key, name, TileSetAreaSize(width, height), left, top),
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

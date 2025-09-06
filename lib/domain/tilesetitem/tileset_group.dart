import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_named_area.dart';

class TileSetGroup extends TileSetNamedArea {
  static final TileSetGroup none = TileSetGroup(id: -1, name: '-', size: TileSetAreaSize(0, 0));

  @override
  Color getHoverColor() => EditorColor.tileGroupHovered.color;

  @override
  Color getTextColor() => EditorColor.tileSetGroup.color;

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2(0, 0);

  TileSetGroup({
    required super.id, //
    required super.name,
    required super.size,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id, //
      'name': name, //
      'indices': tileIndices,
      'width': size.width,
      'height': size.height,
      'output': output?.toJson(),
    };
  }

  factory TileSetGroup.fromJson(Map<String, dynamic> json) {
    TileSetGroup result = switch (json) {
      {
        'id': int id,
        'name': String name, //
        'width': int width, //
        'height': int height, //
      } =>
        TileSetGroup(id: id, name: name, size: TileSetAreaSize(width, height)),
      _ => throw const FormatException('Failed to load TileSetGroup'),
    };
    result.tileIndices = TileSetItem.tileIndicesFromJson(json);
    result.output = TileSetItem.outputFromJson(json);
    return result;
  }

  @override
  String toString() {
    return 'Group $name (#:${tileIndices.length} w:${size.width} h:${size.height})';
  }

  static List<TileSetGroup> groupsFromJson(Map<String, dynamic> json) {
    List<TileSetGroup> result = [];
    List<Map<String, dynamic>> groups = json['groups'] != null ? (json['groups'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var group in groups) {
      result.add(TileSetGroup.fromJson(group));
    }
    return result;
  }

  static List<Map<String, dynamic>> groupsToJson(List<TileSetGroup> groups) {
    List<Map<String, dynamic>> result = [];
    for (var group in groups) {
      result.add(group.toJson());
    }
    return result;
  }
}

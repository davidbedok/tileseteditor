import 'dart:ui';

import 'package:flame/game.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_named_area.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileSetGroup extends TileSetNamedArea implements YateMapper {
  static final TileSetGroup none = TileSetGroup(id: -1, name: '-', size: TileRectSize(0, 0));

  @override
  Color getHoverColor() => EditorColor.groupHovered.color;

  @override
  Color getTextColor() => EditorColor.group.color;

  @override
  Vector2 getRealPosition(double tileWidth, double tileHeight) => Vector2(0, 0);

  @override
  String getType() => 'tileset\'s group';

  TileSetGroup({
    required super.id, //
    required super.name,
    required super.size,
  });

  @override
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

  static List<TileSetGroup> itemsFromJson(Map<String, dynamic> json) {
    List<TileSetGroup> result = [];
    List<Map<String, dynamic>> groups = json['groups'] != null ? (json['groups'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var group in groups) {
      result.add(TileSetGroup.fromJson(group));
    }
    return result;
  }

  factory TileSetGroup.fromJson(Map<String, dynamic> json) {
    TileSetGroup result = switch (json) {
      {
        'id': int id,
        'name': String name, //
        'width': int width, //
        'height': int height, //
      } =>
        TileSetGroup(id: id, name: name, size: TileRectSize(width, height)),
      _ => throw const FormatException('Failed to load TileSetGroup'),
    };
    result.tileIndices = YateItem.tileIndicesFromJson(json);
    result.output = YateItem.outputFromJson(json);
    return result;
  }

  @override
  String toString() {
    return 'Group $name (#:${tileIndices.length} w:${size.width} h:${size.height})';
  }
}

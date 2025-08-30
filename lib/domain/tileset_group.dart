import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/domain/tileset_named_area.dart';

class TileSetGroup extends TileSetNamedArea {
  static final TileSetGroup none = TileSetGroup(-1, '-', TileSetAreaSize(0, 0));

  TileCoord? output;

  TileSetGroup(super.key, super.name, super.size);

  Map<String, dynamic> toJson() {
    return {
      'key': key, //
      'name': name, //
      'tiles': tileIndices,
      'width': size.width,
      'height': size.height,
      'output': output?.toJson(),
    };
  }

  factory TileSetGroup.fromJson(Map<String, dynamic> json) {
    TileSetGroup result = switch (json) {
      {
        'key': int key, //
        'name': String name, //
        'width': int width, //
        'height': int height, //
      } =>
        TileSetGroup(key, name, TileSetAreaSize(width, height)),
      _ => throw const FormatException('Failed to load TileSetGroup'),
    };
    List<int> tileIndices = json['tiles'] != null ? (json['tiles'] as List).map((index) => index as int).toList() : [];
    if (tileIndices.isNotEmpty) {
      result.tileIndices.addAll(tileIndices);
    }

    Map<String, dynamic>? output = json['output'] != null ? (json['output'] as Map<String, dynamic>) : null;
    result.output = output != null ? TileCoord.fromJson(output) : null;

    return result;
  }

  @override
  String toString() {
    return 'Group $name (#:${tileIndices.length} w:${size.width} h:${size.height})';
  }
}

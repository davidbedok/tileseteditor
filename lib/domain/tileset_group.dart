import 'package:tileseteditor/domain/tileset_named_area.dart';

class TileSetGroup extends TileSetNamedArea {
  int width;
  int height;

  TileSetGroup(super.key, super.name, this.width, this.height);

  Map<String, dynamic> toJson() {
    return {
      'key': key, //
      'name': name, //
      'indices': indices,
      'width': width,
      'height': height,
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
        TileSetGroup(key, name, width, height),
      _ => throw const FormatException('Failed to load TileSetGroup'),
    };
    List<int> indices = json['indices'] != null ? (json['indices'] as List).map((index) => index as int).toList() : [];
    if (indices.isNotEmpty) {
      result.indices.addAll(indices);
    }
    return result;
  }

  @override
  String toString() {
    return 'Group $name (#:${indices.length} w:$width h:$height)';
  }
}

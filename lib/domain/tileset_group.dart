import 'package:tileseteditor/domain/named_area_size.dart';
import 'package:tileseteditor/domain/tileset_named_area.dart';

class TileSetGroup extends TileSetNamedArea {
  TileSetGroup(super.key, super.name, super.size);

  Map<String, dynamic> toJson() {
    return {
      'key': key, //
      'name': name, //
      'tiles': tileIndices,
      'width': size.width,
      'height': size.height,
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
        TileSetGroup(key, name, NamedAreaSize(width, height)),
      _ => throw const FormatException('Failed to load TileSetGroup'),
    };
    List<int> tileIndices = json['tiles'] != null ? (json['tiles'] as List).map((index) => index as int).toList() : [];
    if (tileIndices.isNotEmpty) {
      result.tileIndices.addAll(tileIndices);
    }
    return result;
  }

  @override
  String toString() {
    return 'Group $name (#:${tileIndices.length} w:${size.width} h:${size.height})';
  }
}

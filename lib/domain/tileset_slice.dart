import 'package:tileseteditor/domain/named_area_size.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_named_area.dart';

class TileSetSlice extends TileSetNamedArea {
  int left;
  int top;

  TileSetSlice(super.key, super.name, super.size, this.left, this.top);

  bool isInnerCoord(TileCoord coord) {
    return coord.x >= left && coord.x < left + size.width && coord.y >= top && coord.y < top + size.height;
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key, //
      'name': name, //
      'tiles': tileIndices,
      'left': left,
      'top': top,
      'width': size.width,
      'height': size.height,
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
        TileSetSlice(key, name, NamedAreaSize(width, height), left, top),
      _ => throw const FormatException('Failed to load TileSetSlice'),
    };
    List<int> tileIndices = json['tiles'] != null ? (json['tiles'] as List).map((index) => index as int).toList() : [];
    if (tileIndices.isNotEmpty) {
      result.tileIndices.addAll(tileIndices);
    }
    return result;
  }

  @override
  String toString() {
    return 'Slice $name (l:$left t:$top w:${size.width} h:${size.height})';
  }
}

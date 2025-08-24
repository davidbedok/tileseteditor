import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_named_area.dart';

class TileSetSlice extends TileSetNamedArea {
  int left;
  int top;
  int width;
  int height;

  TileSetSlice(super.key, super.name, this.left, this.top, this.width, this.height);

  bool isInnerCoord(TileCoord coord) {
    return coord.x >= left && coord.x < left + width && coord.y >= top && coord.y < top + height;
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key, //
      'name': name, //
      'indices': indices,
      'left': left,
      'top': top,
      'width': width,
      'height': height,
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
        TileSetSlice(key, name, left, top, width, height),
      _ => throw const FormatException('Failed to load TileSetSlice'),
    };
    List<int> indices = json['indices'] != null ? (json['indices'] as List).map((index) => index as int).toList() : [];
    if (indices.isNotEmpty) {
      result.indices.addAll(indices);
    }
    /*
    List<int> indices = [];
    for (int x = result.left; x < result.left + result.width; x++) {
      for (int y = result.top; y < result.top + result.height; y++) {
        indices.add(tileSet.getIndex(TileCoord(x, y)));
      }
    }
    result.indices.addAll(indices);
    */
    return result;
  }

  @override
  String toString() {
    return 'Slice $name (l:$left t:$top w:$width h:$height)';
  }
}

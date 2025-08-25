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
      'tiles': tileIndices,
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
    List<int> tileIndices = json['tiles'] != null ? (json['tiles'] as List).map((index) => index as int).toList() : [];
    if (tileIndices.isNotEmpty) {
      result.tileIndices.addAll(tileIndices);
    }
    return result;
  }

  @override
  String toString() {
    return 'Slice $name (l:$left t:$top w:$width h:$height)';
  }
}

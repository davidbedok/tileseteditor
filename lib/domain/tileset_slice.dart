import 'package:tileseteditor/domain/tile_coord.dart';

class TileSetSlice {
  String name;
  int left;
  int top;
  int width;
  int height;

  TileSetSlice(this.name, this.left, this.top, this.width, this.height);

  bool isCoord(TileCoord coord) {
    return coord.x >= left && coord.x < left + width && coord.y >= top && coord.y < top + height;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name, //
      'left': left,
      'top': top,
      'width': width,
      'height': height,
    };
  }

  factory TileSetSlice.fromJson(Map<String, dynamic> json) {
    TileSetSlice result = switch (json) {
      {
        'name': String name, //
        'left': int left, //
        'top': int top, //
        'width': int width, //
        'height': int height, //
      } =>
        TileSetSlice(name, left, top, width, height),
      _ => throw const FormatException('Failed to load TileSetSlice'),
    };
    return result;
  }

  @override
  String toString() {
    return 'Slice $name $left:$top (w:$width h:$height)';
  }
}

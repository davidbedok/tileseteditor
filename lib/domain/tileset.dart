import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';

class TileSet {
  String name;
  String filePath;
  int tileWidth;
  int tileHeight;
  int margin;
  int spacing;

  List<TileSetSlice> slices = [];

  TileSet({required this.name, required this.filePath, required this.tileWidth, required this.tileHeight, required this.margin, required this.spacing});

  void addSlice(TileSetSlice slice) {
    slices.add(slice);
  }

  TileInfo getTileInfo(TileCoord coord) {
    TileInfo result = TileInfo(type: TileType.free);
    TileSetSlice? slice = findSlice(coord);
    if (slice != null) {
      result = TileInfo(type: TileType.slice, name: slice.name);
    }
    return result;
  }

  TileSetSlice? findSlice(TileCoord coord) {
    TileSetSlice? result;
    for (TileSetSlice slice in slices) {
      if (slice.isCoord(coord)) {
        result = slice;
        break;
      }
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'input': filePath,
      'tile': {'width': tileWidth, 'height': tileHeight, 'margin': margin, 'spacing': spacing},
      'slices': toSlicesJson(),
    };
  }

  List<Map<String, dynamic>> toSlicesJson() {
    List<Map<String, dynamic>> result = [];
    for (var slice in slices) {
      result.add(slice.toJson());
    }
    return result;
  }

  factory TileSet.fromJson(Map<String, dynamic> json) {
    TileSet result = switch (json) {
      {
        'name': String name, //
        'input': String filePath, //
        'tile': {
          'width': int tileWidth, //
          'height': int tileHeight, //
          'margin': int margin,
          'spacing': int spacing,
        }, //
      } =>
        TileSet(name: name, filePath: filePath, tileWidth: tileWidth, tileHeight: tileHeight, margin: margin, spacing: spacing),
      _ => throw const FormatException('Failed to load TileSetProject'),
    };

    List<Map<String, dynamic>> slices = json['slices'] != null ? (json['slices'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var slice in slices) {
      result.addSlice(TileSetSlice.fromJson(slice));
    }
    return result;
  }

  @override
  String toString() {
    return 'TileSet $name (${tileWidth}x$tileHeight) in $filePath';
  }
}

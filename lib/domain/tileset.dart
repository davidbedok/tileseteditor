import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';

class TileSet {
  String name;
  String filePath;
  int tileWidth;
  int tileHeight;
  int margin;
  int spacing;

  int imageWidth;
  int imageHeight;

  List<TileSetSlice> slices = [];
  List<TileSetGroup> groups = [];

  int getMaxTileRow() => imageWidth ~/ tileWidth;
  int getMaxTileColumn() => imageHeight ~/ tileHeight;

  TileSet({
    required this.name,
    required this.filePath,
    required this.tileWidth,
    required this.tileHeight,
    required this.margin,
    required this.spacing,
    required this.imageWidth,
    required this.imageHeight,
  });

  int getIndex(TileCoord coord) {
    return (coord.y - 1) * getMaxTileRow() + coord.x;
  }

  void addSlice(TileSetSlice slice) {
    slices.add(slice);
  }

  void addGroup(TileSetGroup group) {
    groups.add(group);
  }

  TileInfo getTileInfo(TileCoord coord) {
    TileInfo result = TileInfo(type: TileType.free);
    TileSetSlice? slice = findSlice(coord);
    if (slice != null) {
      result = TileInfo(type: TileType.slice, name: slice.name, color: slice.color);
    }

    TileSetGroup? group = findGroup(coord);
    if (group != null) {
      result = TileInfo(type: TileType.group, name: group.name, color: group.color);
    }
    return result;
  }

  TileSetSlice? findSlice(TileCoord coord) {
    TileSetSlice? result;
    for (TileSetSlice slice in slices) {
      if (slice.isInnerCoord(coord)) {
        result = slice;
        break;
      }
    }
    return result;
  }

  TileSetGroup? findGroup(TileCoord coord) {
    TileSetGroup? result;
    for (TileSetGroup group in groups) {
      if (group.indices.contains(getIndex(coord))) {
        result = group;
        break;
      }
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'input': filePath,
      'margin': margin,
      'spacing': spacing,
      'tile': {
        'width': tileWidth, //
        'height': tileHeight,
      },
      'size': {
        'width': imageWidth, //
        'height': imageHeight,
      },
      'slices': toSlicesJson(),
      'groups': toGroupsJson(),
    };
  }

  List<Map<String, dynamic>> toSlicesJson() {
    List<Map<String, dynamic>> result = [];
    for (var slice in slices) {
      result.add(slice.toJson());
    }
    return result;
  }

  List<Map<String, dynamic>> toGroupsJson() {
    List<Map<String, dynamic>> result = [];
    for (var group in groups) {
      result.add(group.toJson());
    }
    return result;
  }

  factory TileSet.fromJson(Map<String, dynamic> json) {
    TileSet result = switch (json) {
      {
        'name': String name, //
        'input': String filePath, //
        'margin': int margin, //
        'spacing': int spacing, //
        'tile': {
          'width': int tileWidth, //
          'height': int tileHeight, //
        }, //
        'size': {
          'width': int imageWidth, //
          'height': int imageHeight, //
        }, //
      } =>
        TileSet(
          name: name,
          filePath: filePath,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          margin: margin,
          spacing: spacing,
          imageWidth: imageWidth,
          imageHeight: imageHeight,
        ),
      _ => throw const FormatException('Failed to load TileSetProject'),
    };

    List<Map<String, dynamic>> slices = json['slices'] != null ? (json['slices'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var slice in slices) {
      result.addSlice(TileSetSlice.fromJson(slice));
    }
    List<Map<String, dynamic>> groups = json['groups'] != null ? (json['groups'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var group in groups) {
      result.addGroup(TileSetGroup.fromJson(group));
    }

    return result;
  }

  @override
  String toString() {
    return 'TileSet $name (${tileWidth}x$tileHeight) in $filePath';
  }
}

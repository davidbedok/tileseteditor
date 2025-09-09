import 'dart:math' as math;
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileGroup extends TileSetProjectItem implements YateMapper {
  static final TileGroup none = TileGroup(
    id: -1, //
    name: '-',
    active: true,
    tileSize: PixelSize(0, 0),
  );

  List<TileGroupFile> files = [];

  @override
  String getDetails() => 'tilegroup';

  TileRectSize calcGroupFileSize(PixelSize imageSize) {
    return TileRectSize(imageSize.widthPx ~/ tileSize.widthPx, imageSize.heightPx ~/ tileSize.heightPx);
  }

  TileGroup({
    required super.id, //
    required super.name,
    required super.active,
    required super.tileSize,
  });

  int getNextFileId() {
    int max = files.isNotEmpty ? files.map((group) => group.id).reduce(math.max) : 0;
    return max + 1;
  }

  static TileGroup clone(TileGroup tileGroup) {
    TileGroup result = TileGroup(
      id: tileGroup.id, //
      name: tileGroup.name,
      active: tileGroup.active,
      tileSize: PixelSize(tileGroup.tileSize.widthPx, tileGroup.tileSize.heightPx),
    );
    return result;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'active': active,
      'tile': {
        'width': tileSize.widthPx, //
        'height': tileSize.heightPx,
      },
      'files': YateMapper.itemsToJson(files),
    };
  }

  static List<TileGroup> itemsFromJson(Map<String, dynamic> json) {
    List<TileGroup> result = [];
    List<Map<String, dynamic>> tileSets = json['tilegroups'] != null
        ? (json['tilegroups'] as List).map((source) => source as Map<String, dynamic>).toList()
        : [];
    for (var tileSet in tileSets) {
      result.add(TileGroup.fromJson(tileSet));
    }
    return result;
  }

  factory TileGroup.fromJson(Map<String, dynamic> json) {
    TileGroup result = switch (json) {
      {
        'id': int id,
        'name': String name, //
        'active': bool active,
        'tile': {
          'width': int tileWidthPx, //
          'height': int tileHeightPx, //
        }, //
      } =>
        TileGroup(id: id, name: name, active: active, tileSize: PixelSize(tileWidthPx, tileHeightPx)),
      _ => throw const FormatException('Failed to load TileGroup'),
    };
    result.files = TileGroupFile.itemsFromJson(json);
    return result;
  }
}

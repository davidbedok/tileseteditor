import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileGroup implements YateMapper {
  static final TileGroup none = TileGroup(
    id: -1, //
    name: '-',
    active: true,
    tileSize: PixelSize(0, 0),
  );

  int id;
  String name;
  bool active;
  PixelSize tileSize;

  List<TileGroupFile> files = [];

  TileGroup({
    required this.id, //
    required this.name,
    required this.active,
    required this.tileSize,
  });

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

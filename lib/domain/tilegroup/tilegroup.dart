import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';

class TileGroup implements YateMapper {
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

import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';

class TileSetProjectItem {
  static final TileSetProjectItem none = TileSetProjectItem(
    id: -1, //
    name: '-',
    active: true,
    tileSize: PixelSize(0, 0),
  );

  int id;
  String name;
  bool active;
  PixelSize tileSize;

  String getDropDownPrefix() => '';
  String getDetails() => '';

  bool isTileSet() => this is TileSet;
  bool isTileGroup() => this is TileGroup;

  TileSetProjectItem({
    required this.id, //
    required this.name,
    required this.active,
    required this.tileSize,
  });
}

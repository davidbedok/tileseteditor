import 'package:tileseteditor/domain/tile_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tilegroup_file.dart';

class TileGroup {
  int id;
  String name;
  bool active;
  TileSize tileSize;

  List<TileGroupFile> files = [];

  TileGroup({
    required this.id, //
    required this.name,
    required this.active,
    required this.tileSize,
  });
}

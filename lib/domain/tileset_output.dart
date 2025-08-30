import 'package:tileseteditor/domain/tile_reference.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_data.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';

class TileSetOutput {
  int tileWidth;
  int tileHeight;
  int width;
  int height;
  TileSetData data = TileSetData(0, 0);

  TileSetOutput({required this.tileWidth, required this.tileHeight, required this.width, required this.height});

  Map<String, dynamic> toJson(List<TileSet> tileSets) {
    return {
      'tile': {'width': tileWidth, 'height': tileHeight},
      'size': {'width': width, 'height': height},
      'data': TileSetData.init(width, height, tileSets).toJson(),
    };
  }

  @override
  String toString() {
    return 'Output [${width}x$height] from (${tileWidth}x$tileHeight) tiles';
  }
}

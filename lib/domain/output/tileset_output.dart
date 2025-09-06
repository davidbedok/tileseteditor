import 'package:tileseteditor/domain/tile_size.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/output/tileset_data.dart';

class TileSetOutput {
  static final TileSetOutput none = TileSetOutput(
    fileName: '', //
    tileSize: TileSize(0, 0),
    width: 0,
    height: 0,
  );

  static const int minOutputWidth = 12;
  static const int maxOutputWidth = 50;
  static const int minOutputHeight = 24;
  static const int maxOutputHeight = 100;

  String fileName;
  TileSize tileSize;
  int width;
  int height;
  TileSetData data = TileSetData(0, 0);

  TileSetOutput({
    required this.fileName, //
    required this.tileSize,
    required this.width,
    required this.height,
  });

  void init() {
    data = TileSetData(0, 0);
  }

  int getMaxOutputLeft(int minWidth, List<TileSet> tileSets) {
    return data.getMaxOutputLeft(minWidth, tileSets);
  }

  int getMaxOutputTop(int minHeight, List<TileSet> tileSets) {
    return data.getMaxOutputTop(minHeight, tileSets);
  }

  Map<String, dynamic> toJson(List<TileSet> tileSets) {
    return {
      'file': fileName,
      'tile': {'width': tileSize.widthPx, 'height': tileSize.heightPx},
      'size': {'width': width, 'height': height},
      'data': TileSetData.init(width, height, tileSets).toJson(),
    };
  }

  @override
  String toString() {
    return 'Output [${width}x$height] from (${tileSize.widthPx}x${tileSize.heightPx}) tiles';
  }
}

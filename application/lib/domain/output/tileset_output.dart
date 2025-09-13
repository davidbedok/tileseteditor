import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/output/tileset_data.dart';

class TileSetOutput {
  static final TileSetOutput none = TileSetOutput(
    fileName: '', //
    tileSize: PixelSize(0, 0),
    size: TileRectSize(0, 0),
  );

  static const int minOutputWidth = 12;
  static const int maxOutputWidth = 50;
  static const int minOutputHeight = 24;
  static const int maxOutputHeight = 100;

  String fileName;
  PixelSize tileSize;
  TileRectSize size;
  TileSetData data = TileSetData(0, 0);

  TileSetOutput({
    required this.fileName, //
    required this.tileSize,
    required this.size,
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
      'size': {'width': size.width, 'height': size.height},
      'data': TileSetData.init(size.width, size.height, tileSets).toJson(),
    };
  }

  @override
  String toString() {
    return 'Output [${size.width}x${size.height}] from (${tileSize.widthPx}x${tileSize.heightPx}) tiles';
  }
}

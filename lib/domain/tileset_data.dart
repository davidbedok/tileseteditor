import 'package:tileseteditor/domain/tile_reference.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';

class TileSetData {
  List<List<TileReference>> tiles = [];

  TileSetData(int width, int height) {
    for (int j = 0; j < height; j++) {
      List<TileReference> row = [];
      for (int i = 0; i < width; i++) {
        row.add(TileReference(tileSetKey: -1, tileIndex: -1));
      }
      tiles.add(row);
    }
  }

  factory TileSetData.init(int width, int height, List<TileSet> tileSets) {
    TileSetData result = TileSetData(width, height);
    for (TileSet tileSet in tileSets) {
      for (TileSetSlice slice in tileSet.slices) {
        if (slice.output != null) {
          int tileIndex = 0;
          for (int j = 0; j < slice.size.height; j++) {
            for (int i = 0; i < slice.size.width; i++) {
              result.tiles[slice.output!.y - 1 + j][slice.output!.x - 1 + i] = TileReference(
                tileSetKey: tileSet.key,
                tileIndex: slice.tileIndices[tileIndex++],
              );
            }
          }
        }
      }
    }
    return result;
  }

  List<List<Map<String, dynamic>>> toJson() {
    List<List<Map<String, dynamic>>> result = [];
    for (List<TileReference> row in tiles) {
      result.add(toRowsJson(row));
    }
    return result;
  }

  List<Map<String, dynamic>> toRowsJson(List<TileReference> row) {
    List<Map<String, dynamic>> result = [];
    for (TileReference tileReference in row) {
      result.add(tileReference.toJson());
    }
    return result;
  }
}

import 'package:tileseteditor/domain/tile_reference.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_tile.dart';

class TileSetData {
  List<List<TileReference>> tiles = [];

  TileSetData(int width, int height) {
    for (int j = 0; j < height; j++) {
      List<TileReference> row = [];
      for (int i = 0; i < width; i++) {
        row.add(TileReference(key: -1, index: -1));
      }
      tiles.add(row);
    }
  }

  int getMaxOutputLeft(int minWidth, List<TileSet> tileSets) {
    int maxLeft = minWidth;
    for (TileSet tileSet in tileSets) {
      for (TileSetSlice slice in tileSet.slices) {
        if (slice.output != null) {
          int currentMaxLeft = slice.output!.left + slice.size.width - 1;
          if (currentMaxLeft > maxLeft) {
            maxLeft = currentMaxLeft;
          }
        }
      }
      for (TileSetGroup group in tileSet.groups) {
        if (group.output != null) {
          int currentMaxLeft = group.output!.left + group.size.width - 1;
          if (currentMaxLeft > maxLeft) {
            maxLeft = currentMaxLeft;
          }
        }
      }
      for (TileSetTile tile in tileSet.tiles) {
        if (tile.output != null) {
          if (tile.output!.left > maxLeft) {
            maxLeft = tile.output!.left;
          }
        }
      }
    }
    return maxLeft;
  }

  int getMaxOutputTop(int minHeight, List<TileSet> tileSets) {
    int maxTop = minHeight;
    for (TileSet tileSet in tileSets) {
      for (TileSetSlice slice in tileSet.slices) {
        if (slice.output != null) {
          int currentMaxHeight = slice.output!.top + slice.size.height - 1;
          if (currentMaxHeight > maxTop) {
            maxTop = currentMaxHeight;
          }
        }
      }
      for (TileSetGroup group in tileSet.groups) {
        if (group.output != null) {
          int currentMaxHeight = group.output!.top + group.size.height - 1;
          if (currentMaxHeight > maxTop) {
            maxTop = currentMaxHeight;
          }
        }
      }
      for (TileSetTile tile in tileSet.tiles) {
        if (tile.output != null) {
          if (tile.output!.top > maxTop) {
            maxTop = tile.output!.top;
          }
        }
      }
    }
    return maxTop;
  }

  factory TileSetData.init(int width, int height, List<TileSet> tileSets) {
    TileSetData result = TileSetData(width, height);
    for (TileSet tileSet in tileSets) {
      for (TileSetSlice slice in tileSet.slices) {
        if (slice.output != null && slice.tileIndices.length == slice.size.height * slice.size.width) {
          int tileIndex = 0;
          for (int j = 0; j < slice.size.height; j++) {
            for (int i = 0; i < slice.size.width; i++) {
              result.tiles[slice.output!.top - 1 + j][slice.output!.left - 1 + i] = TileReference(
                key: tileSet.key, //
                index: slice.tileIndices[tileIndex++],
              );
            }
          }
        }
      }

      for (TileSetGroup group in tileSet.groups) {
        if (group.output != null && group.tileIndices.length == group.size.height * group.size.width) {
          int tileIndex = 0;
          for (int j = 0; j < group.size.height; j++) {
            for (int i = 0; i < group.size.width; i++) {
              result.tiles[group.output!.top - 1 + j][group.output!.left - 1 + i] = TileReference(
                key: tileSet.key, //
                index: group.tileIndices[tileIndex++],
              );
            }
          }
        }
      }

      for (TileSetTile tile in tileSet.tiles) {
        if (tile.output != null && tile.tileIndices.isNotEmpty) {
          result.tiles[tile.output!.top - 1][tile.output!.left - 1] = TileReference(
            key: tileSet.key, //
            index: tile.tileIndices[0],
          );
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

import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';

class EditorState {
  // TileSet tileSet;

  List<TileCoord> selectedFreeTiles = [];
  List<TileCoord> selectedGarbageTiles = [];
  TileInfo? selectedTileInfo;

  EditorState();

  bool isSelected(TileInfo info) {
    bool result = false;
    switch (info.type) {
      case TileType.free:
        result = selectedFreeTiles.where((c) => c.x == info.coord.x && c.y == info.coord.y).isNotEmpty;
      case TileType.garbage:
        result = selectedGarbageTiles.where((c) => c.x == info.coord.x && c.y == info.coord.y).isNotEmpty;
      case TileType.slice:
      case TileType.group:
        result = selectedTileInfo != null && selectedTileInfo == info;
    }
    return result;
  }

  void selectTile(TileInfo info) {
    switch (info.type) {
      case TileType.free:
        print('free $selectedFreeTiles');
        if (selectedFreeTiles.contains(info.coord)) {
          print('remove..');
          selectedFreeTiles.removeWhere((c) => c.x == info.coord.x && c.y == info.coord.y);
        } else {
          print('add..');
          selectedFreeTiles.add(info.coord);
        }
      case TileType.slice:
      case TileType.group:
        if (selectedTileInfo == info) {
          selectedTileInfo = null;
        } else {
          selectedTileInfo = info;
        }
      case TileType.garbage:
        if (selectedGarbageTiles.contains(info.coord)) {
          selectedGarbageTiles.removeWhere((c) => c.x == info.coord.x && c.y == info.coord.y);
        } else {
          selectedGarbageTiles.add(info.coord);
        }
    }
  }
}

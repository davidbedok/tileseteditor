import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset.dart';

class EditorState {
  // TileSet tileSet;

  List<TileCoord> selectedFreeTiles = [];
  List<TileCoord> selectedGarbageTiles = [];
  TileInfo? selectedSliceOrGroup;

  List<void Function(EditorState state, TileInfo tileInfo)> onSelectedEventHandlers = [];

  EditorState();

  void subscribeOnSelected(void Function(EditorState state, TileInfo tileInfo) eventHandler) {
    onSelectedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnSelected(void Function(EditorState state, TileInfo tileInfo) eventHandler) {
    onSelectedEventHandlers.remove(eventHandler);
  }

  bool isSelected(TileInfo info) {
    bool result = false;
    switch (info.type) {
      case TileType.free:
        result = selectedFreeTiles.where((c) => c.x == info.coord.x && c.y == info.coord.y).isNotEmpty;
      case TileType.garbage:
        result = selectedGarbageTiles.where((c) => c.x == info.coord.x && c.y == info.coord.y).isNotEmpty;
      case TileType.slice:
      case TileType.group:
        result = selectedSliceOrGroup != null && selectedSliceOrGroup == info;
    }
    return result;
  }

  void selectTile(TileInfo info) {
    switch (info.type) {
      case TileType.free:
        if (selectedFreeTiles.contains(info.coord)) {
          selectedFreeTiles.removeWhere((c) => c.x == info.coord.x && c.y == info.coord.y);
        } else {
          selectedFreeTiles.add(info.coord);
        }
      case TileType.slice:
      case TileType.group:
        if (selectedSliceOrGroup == info) {
          selectedSliceOrGroup = null;
        } else {
          selectedSliceOrGroup = info;
        }
      case TileType.garbage:
        if (selectedGarbageTiles.contains(info.coord)) {
          selectedGarbageTiles.removeWhere((c) => c.x == info.coord.x && c.y == info.coord.y);
        } else {
          selectedGarbageTiles.add(info.coord);
        }
    }
    for (var eventHandler in onSelectedEventHandlers) {
      eventHandler.call(this, info);
    }
  }

  void selectAllFree(TileSet tileSet) {
    selectedFreeTiles.clear();
    for (int index = 0; index < tileSet.getMaxTileIndex(); index++) {
      if (tileSet.isFree(index)) {
        selectedFreeTiles.add(tileSet.getTileCoord(index));
      }
    }
  }
}

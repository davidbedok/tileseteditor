import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset.dart';

class EditorState {
  List<TileCoord> selectedFreeTiles = [];
  List<TileCoord> selectedGarbageTiles = [];
  TileInfo? selectedSlice;
  TileInfo? selectedGroup;

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
        result = selectedSlice != null && selectedSlice == info;
      case TileType.group:
        result = selectedGroup != null && selectedGroup == info;
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
        if (selectedSlice == info) {
          selectedSlice = null;
        } else {
          selectedSlice = info;
          selectedGroup = null;
        }
      case TileType.group:
        if (selectedGroup == info) {
          selectedGroup = null;
        } else {
          selectedGroup = info;
          selectedSlice = null;
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

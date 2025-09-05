import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tile_type.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';

class SplitterState {
  List<TileCoord> selectedFreeTiles = [];
  List<TileCoord> selectedGarbageTiles = [];
  TileInfo? selectedSliceInfo;
  TileInfo? selectedGroupInfo;

  List<void Function(SplitterState state, TileInfo tileInfo)> onSelectedEventHandlers = [];

  SplitterState();

  void subscribeOnSelected(void Function(SplitterState state, TileInfo tileInfo) eventHandler) {
    onSelectedEventHandlers.add(eventHandler);
  }

  void unsubscribeOnSelected(void Function(SplitterState state, TileInfo tileInfo) eventHandler) {
    onSelectedEventHandlers.remove(eventHandler);
  }

  bool isSelected(TileInfo info) {
    bool result = false;
    switch (info.type) {
      case TileType.free:
        result = selectedFreeTiles.where((c) => c.left == info.coord.left && c.top == info.coord.top).isNotEmpty;
      case TileType.garbage:
        result = selectedGarbageTiles.where((c) => c.left == info.coord.left && c.top == info.coord.top).isNotEmpty;
      case TileType.slice:
        result = selectedSliceInfo != null && selectedSliceInfo == info;
      case TileType.group:
        result = selectedGroupInfo != null && selectedGroupInfo == info;
    }
    return result;
  }

  void selectSlice(TileSetSlice slice) {
    if (slice != TileSetSlice.none) {
      selectTile(TileInfo(type: TileType.slice, name: slice.name, key: slice.key, coord: TileCoord(slice.left, slice.top), color: slice.color));
    } else {
      selectedSliceInfo = null;
    }
  }

  void selectGroup(TileSet tileSet, TileSetGroup group) {
    if (group != TileSetGroup.none) {
      if (group.tileIndices.isNotEmpty) {
        TileCoord coord = tileSet.getTileCoord(group.tileIndices.first);
        selectTile(TileInfo(type: TileType.group, name: group.name, key: group.key, coord: coord, color: group.color));
      }
    } else {
      selectedGroupInfo = null;
    }
  }

  void selectTile(TileInfo info) {
    switch (info.type) {
      case TileType.free:
        if (selectedFreeTiles.contains(info.coord)) {
          selectedFreeTiles.removeWhere((c) => c.left == info.coord.left && c.top == info.coord.top);
        } else {
          selectedFreeTiles.add(info.coord);
        }
      case TileType.slice:
        if (selectedSliceInfo == info) {
          selectedSliceInfo = null;
        } else {
          selectedSliceInfo = info;
          selectedGroupInfo = null;
        }
      case TileType.group:
        if (selectedGroupInfo == info) {
          selectedGroupInfo = null;
        } else {
          selectedGroupInfo = info;
          selectedSliceInfo = null;
        }
      case TileType.garbage:
        if (selectedGarbageTiles.contains(info.coord)) {
          selectedGarbageTiles.removeWhere((c) => c.left == info.coord.left && c.top == info.coord.top);
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

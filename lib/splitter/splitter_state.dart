import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';

class SplitterState {
  YateItem tileSetItem = YateItem.none;
  List<TileCoord> selectedFreeTiles = [];
  List<TileCoord> selectedGarbageTiles = [];

  List<void Function(SplitterState state, YateItem tileSetItem)> selectionEventHandlers = [];

  SplitterState();

  void subscribeSelection(void Function(SplitterState state, YateItem tileSetItem) eventHandler) {
    selectionEventHandlers.add(eventHandler);
  }

  void unsubscribeSelection(void Function(SplitterState state, YateItem tileSetItem) eventHandler) {
    selectionEventHandlers.remove(eventHandler);
  }

  bool isSelected(TileInfo info) {
    bool result = false;
    if (info.tileSetItem == TileSetTile.freeTile) {
      result = selectedFreeTiles.where((c) => c.left == info.coord.left && c.top == info.coord.top).isNotEmpty;
    } else if (info.tileSetItem == TileSetTile.garbageTile) {
      result = selectedGarbageTiles.where((c) => c.left == info.coord.left && c.top == info.coord.top).isNotEmpty;
    } else if (info.tileSetItem is TileSetSlice || info.tileSetItem is TileSetGroup) {
      result = tileSetItem == info.tileSetItem;
    }
    return result;
  }

  void unselectTileSetItem() {
    tileSetItem = YateItem.none;
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(this, tileSetItem);
    }
  }

  void selectTileSetItem(YateItem tileSetItem) {
    if (this.tileSetItem == tileSetItem) {
      this.tileSetItem = YateItem.none;
    } else {
      this.tileSetItem = tileSetItem;
    }
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(this, tileSetItem);
    }
  }

  void selectTile(TileInfo info) {
    if (info.tileSetItem == TileSetTile.freeTile) {
      if (selectedFreeTiles.contains(info.coord)) {
        selectedFreeTiles.removeWhere((c) => c.left == info.coord.left && c.top == info.coord.top);
      } else {
        selectedFreeTiles.add(info.coord);
      }
    } else if (info.tileSetItem == TileSetTile.garbageTile) {
      if (selectedGarbageTiles.contains(info.coord)) {
        selectedGarbageTiles.removeWhere((c) => c.left == info.coord.left && c.top == info.coord.top);
      } else {
        selectedGarbageTiles.add(info.coord);
      }
    } else if (info.tileSetItem is TileSetSlice || info.tileSetItem is TileSetGroup) {
      if (tileSetItem == info.tileSetItem) {
        tileSetItem = YateItem.none;
      } else {
        tileSetItem = info.tileSetItem;
      }
    }
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(this, tileSetItem);
    }
  }

  void selectAllFree(TileSet tileSet) {
    selectedFreeTiles.clear();
    for (int index = 0; index < tileSet.getMaxTileIndex(); index++) {
      if (tileSet.isFreeByIndex(index)) {
        selectedFreeTiles.add(tileSet.getTileCoord(index));
      }
    }
  }
}

import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';

class SplitterState {
  YateItem yateItem = YateItem.none;
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
      result = yateItem == info.tileSetItem;
    }
    return result;
  }

  void unselectTileSetItem() {
    yateItem = YateItem.none;
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(this, yateItem);
    }
  }

  void selectTileSetItem(YateItem yateItem) {
    if (this.yateItem == yateItem) {
      this.yateItem = YateItem.none;
    } else {
      this.yateItem = yateItem;
    }
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(this, yateItem);
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
      if (yateItem == info.tileSetItem) {
        yateItem = YateItem.none;
      } else {
        yateItem = info.tileSetItem;
      }
    }
    for (var eventHandler in selectionEventHandlers) {
      eventHandler.call(this, yateItem);
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

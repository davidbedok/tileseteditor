import 'dart:math' as math;
import 'dart:ui' as dui;

import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_indexed_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/tileset_change_type.dart';
import 'package:tileseteditor/domain/tileset_garbage.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_group.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_slice.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_tile.dart';
import 'package:tileseteditor/utils/image_utils.dart';

class TileSet {
  static final TileSet none = TileSet(
    key: -1,
    name: '-',
    active: true,
    filePath: '',
    imageHeight: 0,
    imageWidth: 0,
    margin: 0,
    spacing: 0,
    tileHeight: 0,
    tileWidth: 0,
  );

  int key;
  String name;
  bool active;
  String filePath;
  int tileWidth;
  int tileHeight;
  int margin;
  int spacing;

  int imageWidth;
  int imageHeight;
  dui.Image? image;

  List<TileSetSlice> slices = [];
  List<TileSetGroup> groups = [];
  List<TileSetTile> tiles = [];
  TileSetGarbage garbage = TileSetGarbage();

  // FIXME do we need it here?
  List<void Function(TileSet tileSet, TileSetChangeType type)> onChangedEventHandlers = [];

  int getMaxTileRow() => imageWidth ~/ tileWidth;
  int getMaxTileColumn() => imageHeight ~/ tileHeight;
  int getMaxTileIndex() => getMaxTileRow() * getMaxTileColumn() - 1;

  List<TileSetGroup> getGroupsWithNone() {
    List<TileSetGroup> result = [];
    result.add(TileSetGroup.none);
    result.addAll(groups);
    return result;
  }

  List<TileSetSlice> getSlicesWithNone() {
    List<TileSetSlice> result = [];
    result.add(TileSetSlice.none);
    result.addAll(slices);
    return result;
  }

  TileSet({
    required this.key,
    required this.name,
    required this.active,
    required this.filePath,
    required this.tileWidth,
    required this.tileHeight,
    required this.margin,
    required this.spacing,
    required this.imageWidth,
    required this.imageHeight,
  });

  Future<void> loadImage(TileSetProject project) async {
    image = await ImageUtils.getImage(project.getTileSetFilePath(this));
  }

  void initOutput() {
    for (TileSetSlice slice in slices) {
      slice.output = null;
    }
    for (TileSetGroup group in groups) {
      group.output = null;
    }
    tiles.clear();
    /*
    for (TileSetTile tile in tiles) {
      tile.output = null;
    }*/
  }

  // FIXME do we need it here?
  void subscribeOnChanged(void Function(TileSet tileSet, TileSetChangeType type) eventHandler) {
    onChangedEventHandlers.add(eventHandler);
  }

  // FIXME do we need it here?
  void unsubscribeOnChanged(void Function(TileSet tileSet, TileSetChangeType type) eventHandler) {
    onChangedEventHandlers.remove(eventHandler);
  }

  // FIXME do we need it here?
  void callEventHandlers(TileSetChangeType type) {
    for (var eventHandler in onChangedEventHandlers) {
      eventHandler.call(this, type);
    }
  }

  int getNextKey() {
    int result = 0;
    int maxSliceKey = slices.isNotEmpty ? slices.map((slice) => slice.key).reduce(math.max) : 0;
    int maxGroupKey = groups.isNotEmpty ? groups.map((group) => group.key).reduce(math.max) : 0;
    return [result, maxSliceKey, maxGroupKey].reduce(math.max) + 1;
  }

  bool isFreeByCoord(TileCoord coord) {
    return getTileInfo(coord).tileSetItem == TileSetTile.freeTile;
  }

  bool isFreeByIndex(int index) {
    bool result = true;
    if (garbage.tileIndices.contains(index)) {
      result = false;
    }
    if (result) {
      for (var slice in slices) {
        if (slice.tileIndices.contains(index)) {
          result = false;
          break;
        }
      }
    }
    if (result) {
      for (var group in groups) {
        if (group.tileIndices.contains(index)) {
          result = false;
          break;
        }
      }
    }
    return result;
  }

  TileCoord getTileCoord(int index) {
    int maxTileRow = getMaxTileRow();
    return TileCoord(index % maxTileRow + 1, index ~/ maxTileRow + 1);
  }

  TileIndexedCoord getTileIndexedCoord(int index) {
    int maxTileRow = getMaxTileRow();
    return TileIndexedCoord(index, index % maxTileRow + 1, index ~/ maxTileRow + 1);
  }

  int getIndex(TileCoord coord) {
    return (coord.top - 1) * getMaxTileRow() + coord.left - 1;
  }

  void addSlice(TileSetSlice slice) {
    slices.add(slice);
    callEventHandlers(TileSetChangeType.sliceCreated);
  }

  void addGroup(TileSetGroup group) {
    groups.add(group);
    callEventHandlers(TileSetChangeType.groupCreated);
  }

  void addTile(TileSetTile tile) {
    tiles.removeWhere((current) => current.left == tile.left && current.top == tile.top);
    tiles.add(tile);
    // callEventHandlers(TileSetChangeType.groupCreated);
  }

  void addGarbage(List<TileCoord> coords) {
    for (TileCoord coord in coords) {
      if (!garbage.tileIndices.contains(getIndex(coord))) {
        garbage.tileIndices.add(getIndex(coord));
        callEventHandlers(TileSetChangeType.tileDropped);
      }
    }
  }

  void removeGarbage(List<TileCoord> coords) {
    for (TileCoord coord in coords) {
      if (garbage.tileIndices.contains(getIndex(coord))) {
        garbage.tileIndices.remove(getIndex(coord));
        callEventHandlers(TileSetChangeType.garbageDropped);
      }
    }
  }

  void remove(TileSetItem tileSetItem) {
    if (tileSetItem is TileSetSlice) {
      slices.remove(tileSetItem);
      callEventHandlers(TileSetChangeType.sliceRemoved); // FIXME do not handle events here...
    } else if (tileSetItem is TileSetGroup) {
      groups.remove(tileSetItem);
      callEventHandlers(TileSetChangeType.groupRemoved); // FIXME do not handle events here...
    }
  }

  TileInfo getTileInfo(TileCoord coord) {
    TileSetItem result = TileSetTile.freeTile;
    TileSetSlice? slice = findSlice(coord);
    if (slice != null) {
      result = slice;
    } else {
      TileSetGroup? group = findGroup(coord);
      if (group != null) {
        result = group;
      } else {
        if (garbage.tileIndices.contains(getIndex(coord))) {
          result = TileSetTile.garbageTile;
        }
      }
    }
    return TileInfo(coord: coord, tileSetItem: result);
  }

  TileSetSlice? findSlice(TileCoord coord) {
    TileSetSlice? result;
    for (TileSetSlice slice in slices) {
      if (slice.isInnerCoord(coord)) {
        result = slice;
        break;
      }
    }
    return result;
  }

  TileSetSlice? findSliceByKey(int key) {
    return slices.where((slice) => slice.key == key).first;
  }

  TileSetGroup? findGroup(TileCoord coord) {
    TileSetGroup? result;
    for (TileSetGroup group in groups) {
      if (group.tileIndices.contains(getIndex(coord))) {
        result = group;
        break;
      }
    }
    return result;
  }

  TileSetGroup? findGroupByKey(int key) {
    return groups.where((group) => group.key == key).first;
  }

  TileSetTile? findTile(TileCoord coord) {
    TileSetTile? result;
    List<TileSetTile> tileSetTiles = tiles.where((tile) => tile.left == coord.left && tile.top == coord.top).toList();
    if (tileSetTiles.isNotEmpty) {
      result = tileSetTiles.first;
    }
    return result;
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'active': active,
      'file': filePath,
      'margin': margin,
      'spacing': spacing,
      'tile': {
        'width': tileWidth, //
        'height': tileHeight,
      },
      'size': {
        'width': imageWidth, //
        'height': imageHeight,
      },
      'slices': TileSetSlice.slicestoJson(slices),
      'groups': TileSetGroup.groupsToJson(groups),
      'tiles': TileSetTile.tilesToJson(this, tiles),
      'garbage': garbage.toJson(),
    };
  }

  factory TileSet.fromJson(Map<String, dynamic> json) {
    TileSet result = switch (json) {
      {
        'key': int key,
        'name': String name, //
        'active': bool active,
        'file': String filePath, //
        'margin': int margin, //
        'spacing': int spacing, //
        'tile': {
          'width': int tileWidth, //
          'height': int tileHeight, //
        }, //
        'size': {
          'width': int imageWidth, //
          'height': int imageHeight, //
        }, //
      } =>
        TileSet(
          key: key,
          name: name,
          active: active,
          filePath: filePath,
          tileWidth: tileWidth,
          tileHeight: tileHeight,
          margin: margin,
          spacing: spacing,
          imageWidth: imageWidth,
          imageHeight: imageHeight,
        ),
      _ => throw const FormatException('Failed to load TileSet'),
    };
    result.slices = TileSetSlice.slicesFromJson(result, json);
    result.groups = TileSetGroup.groupsFromJson(json);
    result.tiles = TileSetTile.tilesFromJson(json);
    result.garbage = TileSetGarbage.fromJson(json['garbage']);
    return result;
  }

  @override
  String toString() {
    return 'TileSet $name (${tileWidth}x$tileHeight) in $filePath';
  }

  static TileSet clone(TileSet tileSet) {
    TileSet result = TileSet(
      key: tileSet.key, //
      name: tileSet.name, //
      active: tileSet.active,
      filePath: tileSet.filePath,
      imageHeight: tileSet.imageHeight,
      imageWidth: tileSet.imageWidth,
      margin: tileSet.margin,
      spacing: tileSet.spacing,
      tileHeight: tileSet.tileHeight,
      tileWidth: tileSet.tileWidth,
    );
    return result;
  }
}

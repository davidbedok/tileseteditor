import 'dart:math' as math;
import 'dart:ui' as dui;

import 'package:tileseteditor/domain/project_item.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_indexed_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/domain/pixel_size.dart';
import 'package:tileseteditor/domain/tileset/tileset_change_type.dart';
import 'package:tileseteditor/domain/tileset/tileset_garbage.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';
import 'package:tileseteditor/domain/yate_mapper.dart';
import 'package:tileseteditor/utils/image_utils.dart';

class TileSet extends YateProjectItem implements YateMapper {
  static final TileSet none = TileSet(
    id: -1,
    key: -1,
    name: '-',
    active: true,
    filePath: '',
    imageSize: PixelSize(0, 0),
    margin: 0,
    spacing: 0,
    tileSize: PixelSize(0, 0),
  );

  int key;
  String filePath;
  int margin;
  int spacing;

  PixelSize imageSize;
  dui.Image? image;

  List<TileSetSlice> slices = [];
  List<TileSetGroup> groups = [];
  List<TileSetTile> tiles = [];
  TileSetGarbage garbage = TileSetGarbage();

  // FIXME do we need it here?
  List<void Function(TileSet tileSet, TileSetChangeType type)> onChangedEventHandlers = [];

  @override
  String getDropDownPrefix() => 'TileSet splitter and output editor';

  @override
  String getDetails() => '${getMaxTileIndex()} tiles';

  int getMaxTileRow() => imageSize.widthPx ~/ tileSize.widthPx;
  int getMaxTileColumn() => imageSize.heightPx ~/ tileSize.heightPx;
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
    required super.id,
    required super.name,
    required super.active,
    required super.tileSize,
    required this.key,
    required this.filePath,
    required this.margin,
    required this.spacing,
    required this.imageSize,
  });

  Future<void> loadImage(YateProject project) async {
    image = await ImageUtils.getImage(project.getTileSetPath(this));
  }

  void initOutput() {
    for (TileSetSlice slice in slices) {
      slice.output = null;
    }
    for (TileSetGroup group in groups) {
      group.output = null;
    }
    tiles.clear();
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

  int getNextSliceId() {
    int max = slices.isNotEmpty ? slices.map((slice) => slice.id).reduce(math.max) : -1;
    return max + 1;
  }

  int getNextGroupId() {
    int max = groups.isNotEmpty ? groups.map((group) => group.id).reduce(math.max) : -1;
    return max + 1;
  }

  int getNextTileId() {
    int max = tiles.isNotEmpty ? tiles.map((tile) => tile.id).reduce(math.max) : -1;
    return max + 1;
  }

  bool isFreeByCoord(TileCoord coord) {
    return getTileInfo(coord).item == TileSetTile.freeTile;
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
    tiles.removeWhere((current) => current.coord.left == tile.coord.left && current.coord.top == tile.coord.top);
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

  void remove(YateItem tileSetItem) {
    if (tileSetItem is TileSetSlice) {
      slices.remove(tileSetItem);
      callEventHandlers(TileSetChangeType.sliceRemoved); // FIXME do not handle events here...
    } else if (tileSetItem is TileSetGroup) {
      groups.remove(tileSetItem);
      callEventHandlers(TileSetChangeType.groupRemoved); // FIXME do not handle events here...
    }
  }

  TileInfo getTileInfo(TileCoord coord) {
    YateItem result = TileSetTile.freeTile;
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
    return TileInfo(coord: coord, item: result);
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

  TileSetSlice? findSliceById(int id) {
    return slices.where((slice) => slice.id == id).first;
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

  TileSetGroup? findGroupById(int id) {
    return groups.where((group) => group.id == id).first;
  }

  TileSetTile? findTile(TileCoord coord) {
    TileSetTile? result;
    List<TileSetTile> tileSetTiles = tiles.where((tile) => tile.coord.left == coord.left && tile.coord.top == coord.top).toList();
    if (tileSetTiles.isNotEmpty) {
      result = tileSetTiles.first;
    }
    return result;
  }

  static TileSet clone(TileSet tileSet) {
    TileSet result = TileSet(
      id: tileSet.id, //
      key: tileSet.key,
      name: tileSet.name,
      active: tileSet.active,
      filePath: tileSet.filePath,
      imageSize: PixelSize(tileSet.imageSize.widthPx, tileSet.imageSize.heightPx),
      margin: tileSet.margin,
      spacing: tileSet.spacing,
      tileSize: PixelSize(tileSet.tileSize.widthPx, tileSet.tileSize.heightPx),
    );
    return result;
  }

  @override
  Map<String, dynamic> toJson() {
    slices.sort((a, b) => a.id.compareTo(b.id));
    groups.sort((a, b) => a.id.compareTo(b.id));
    tiles.sort((a, b) => a.id.compareTo(b.id));
    return {
      'id': id,
      'key': key,
      'name': name,
      'active': active,
      'file': filePath,
      'margin': margin,
      'spacing': spacing,
      'tile': {
        'width': tileSize.widthPx, //
        'height': tileSize.heightPx,
      },
      'image': {
        'width': imageSize.widthPx, //
        'height': imageSize.heightPx,
      },
      'slices': YateMapper.itemsToJson(slices),
      'groups': YateMapper.itemsToJson(groups),
      'tiles': TileSetTile.tilesToJson(this, tiles),
      'garbage': garbage.toJson(),
    };
  }

  static List<TileSet> itemsFromJson(Map<String, dynamic> json) {
    List<TileSet> result = [];
    List<Map<String, dynamic>> tileSets = json['tilesets'] != null ? (json['tilesets'] as List).map((source) => source as Map<String, dynamic>).toList() : [];
    for (var tileSet in tileSets) {
      result.add(TileSet.fromJson(tileSet));
    }
    return result;
  }

  factory TileSet.fromJson(Map<String, dynamic> json) {
    TileSet result = switch (json) {
      {
        'id': int id,
        'key': int key,
        'name': String name, //
        'active': bool active,
        'file': String filePath, //
        'margin': int margin, //
        'spacing': int spacing, //
        'tile': {
          'width': int tileWidthPx, //
          'height': int tileHeightPx, //
        }, //
        'image': {
          'width': int imageWidthPx, //
          'height': int imageHeightPx, //
        }, //
      } =>
        TileSet(
          id: id,
          key: key,
          name: name,
          active: active,
          filePath: filePath,
          tileSize: PixelSize(tileWidthPx, tileHeightPx),
          margin: margin,
          spacing: spacing,
          imageSize: PixelSize(imageWidthPx, imageHeightPx),
        ),
      _ => throw const FormatException('Failed to load TileSet'),
    };
    result.slices = TileSetSlice.itemsFromJson(result, json);
    result.groups = TileSetGroup.itemsFromJson(json);
    result.tiles = TileSetTile.itemsFromJson(json);
    result.garbage = TileSetGarbage.fromJson(json['garbage']);
    return result;
  }

  @override
  String toString() {
    return 'TileSet $name (${tileSize.widthPx}x${tileSize.heightPx}) in $filePath';
  }
}

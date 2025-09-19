import 'package:flame/components.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/output/tileset_output.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';
import 'package:tileseteditor/overview/flame/component/overview_tilegroup_file_component.dart';
import 'package:tileseteditor/overview/flame/overview_editor_game.dart';
import 'package:tileseteditor/overview/flame/component/overview_output_tile_component.dart';
import 'package:tileseteditor/overview/flame/component/overview_tileset_group_component.dart';
import 'package:tileseteditor/overview/flame/component/overview_tileset_tile_component.dart';
import 'package:tileseteditor/overview/flame/component/overview_tileset_slice_component.dart';
import 'package:tileseteditor/overview/flame/component/overview_yate_component.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class OverviewEditorWorld extends World with HasGameReference<OverviewEditorGame>, HasCollisionDetection {
  static const int movePriority = 1000;
  static const double dragTolarance = 5;
  static double cameraButtonDim = 30;
  static double cameraButtonSpace = 5;

  OverviewYateComponent? selected;
  List<OverviewOutputTileComponent> outputTiles = [];

  int _actionKey = -1;

  void setAction(int actionKey) => _actionKey = actionKey;
  int get actionKey => _actionKey;

  OverviewEditorWorld();

  void unselect() {
    if (selected != null) {
      select(selected!);
    }
  }

  void select(OverviewYateComponent component, {bool force = false}) {
    if (force) {
      setSelected(component);
    } else {
      if (selected != null) {
        if (selected == component) {
          selected = null;
          game.outputState.yateItem.unselect();
        } else {
          setSelected(component);
        }
      } else {
        setSelected(component);
      }
    }
  }

  void setSelected(OverviewYateComponent component) {
    selected = component;
    game.outputState.yateItem.select(component.getItem());
  }

  bool isSelected(OverviewYateComponent component) {
    return selected == component;
  }

  bool canAccept(OverviewOutputTileComponent topLeftTile, OverviewYateComponent component) {
    bool result = true;
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        OverviewOutputTileComponent? tile = getOverviewTileComponent(i, j);
        if (tile == null || !tile.canAccept(component)) {
          result = false;
        }
      }
    }
    return result;
  }

  void place(OverviewOutputTileComponent topLeftTile, OverviewYateComponent component) {
    component.release();
    int numberOfPlacedTiles = 0;
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        OverviewOutputTileComponent? tile = getOverviewTileComponent(i, j);
        if (tile != null && tile.canAccept(component)) {
          tile.store(component);
          numberOfPlacedTiles++;
        }
      }
    }
    if (numberOfPlacedTiles == component.areaSize.width * component.areaSize.height) {
      component.placeOutput(topLeftTile);
      game.outputState.yateItem.select(component.getItem());
    }
  }

  void placeSilent(OverviewOutputTileComponent topLeftTile, OverviewYateComponent component) {
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        OverviewOutputTileComponent? tile = getOverviewTileComponent(i, j);
        if (tile != null && tile.canAccept(component)) {
          tile.store(component);
        }
      }
    }
  }

  bool moveByKey(int atlasX, int atlasY) {
    bool result = false;
    if (selected != null) {
      OverviewOutputTileComponent? newTopLeftOutputTile = getOverviewTileComponent(atlasX, atlasY);
      if (newTopLeftOutputTile != null && canAccept(newTopLeftOutputTile, selected!)) {
        selected!.doMove(
          newTopLeftOutputTile.position,
          speed: 15.0,
          onComplete: () {
            place(newTopLeftOutputTile, selected!);
          },
        );
      }
    }
    return result;
  }

  OverviewOutputTileComponent? getOverviewTileComponent(int atlasX, int atlasY) {
    OverviewOutputTileComponent? result;
    if (atlasX >= 0 && atlasX < game.project.output.size.width && atlasY >= 0 && atlasY < game.project.output.size.height) {
      result = outputTiles.where((outputTile) => outputTile.atlasX == atlasX && outputTile.atlasY == atlasY).first;
    }
    return result;
  }

  void removeTileSetItem(YateItem tileSetItem) {
    if (tileSetItem.output != null) {
      OverviewOutputTileComponent? outputTile = getOverviewTileComponent(tileSetItem.output!.left - 1, tileSetItem.output!.top - 1);
      if (outputTile != null && outputTile.isUsed()) {
        outputTile.removeStoredTileSetItem();
      }
    }
  }

  void removeAllTileSetItem() {
    for (OverviewOutputTileComponent outputTile in outputTiles) {
      if (outputTile.isUsed()) {
        outputTile.removeStoredTileSetItem();
      }
    }
    game.project.initOutput();
  }

  @override
  Future<void> onLoad() async {
    initOutputComponents(0, 0);
    initTileSetComponents();
    initTileGroupFileComponents();
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2(0, 0);
  }

  void initTileGroupFileComponents() {
    for (TileGroup tileGroup in game.project.tileGroups) {
      for (TileGroupFile file in tileGroup.files) {
        if (file.output != null) {
          OverviewOutputTileComponent? topLeftOutputTile = getOverviewTileComponent(file.output!.left - 1, file.output!.top - 1);
          if (topLeftOutputTile != null) {
            OverviewTileGroupFileComponent fileComponent = OverviewTileGroupFileComponent(
              projectItem: tileGroup,
              file: file,
              originalPosition: topLeftOutputTile.position,
              position: topLeftOutputTile.position,
              external: true,
            );
            placeSilent(topLeftOutputTile, fileComponent);
            add(fileComponent);
          }
        }
      }
    }
  }

  void initTileSetComponents() {
    for (TileSet tileSet in game.project.tileSets) {
      initOtherTileSetSlices(tileSet);
      initOtherTileSetGroups(tileSet);
      initOtherTileSetTiles(tileSet);
    }
  }

  void initOtherTileSetSlices(TileSet tileSet) {
    for (TileSetSlice slice in tileSet.slices) {
      if (slice.output != null) {
        OverviewOutputTileComponent? topLeftOutputTile = getOverviewTileComponent(slice.output!.left - 1, slice.output!.top - 1);
        if (topLeftOutputTile != null) {
          OverviewTileSetSliceComponent sliceComponent = OverviewTileSetSliceComponent(
            projectItem: tileSet,
            slice: slice,
            originalPosition: topLeftOutputTile.position,
            position: topLeftOutputTile.position,
            external: true,
          );
          placeSilent(topLeftOutputTile, sliceComponent);
          add(sliceComponent);
        }
      }
    }
  }

  void initOtherTileSetGroups(TileSet tileSet) {
    for (TileSetGroup group in tileSet.groups) {
      if (group.output != null) {
        OverviewOutputTileComponent? topLeftOutputTile = getOverviewTileComponent(group.output!.left - 1, group.output!.top - 1);
        if (topLeftOutputTile != null) {
          OverviewTileSetGroupComponent groupComponent = OverviewTileSetGroupComponent(
            projectItem: tileSet,
            group: group,
            originalPosition: topLeftOutputTile.position,
            position: topLeftOutputTile.position,
            external: true,
          );
          placeSilent(topLeftOutputTile, groupComponent);
          add(groupComponent);
        }
      }
    }
  }

  void initOtherTileSetTiles(TileSet tileSet) {
    int atlasMaxX = tileSet.image!.width ~/ tileSet.tileSize.widthPx;
    int atlasMaxY = tileSet.image!.height ~/ tileSet.tileSize.heightPx;
    for (int i = 0; i < atlasMaxX; i++) {
      for (int j = 0; j < atlasMaxY; j++) {
        TileCoord coord = TileCoord(i + 1, j + 1);
        if (tileSet.isFreeByIndex(tileSet.getIndex(coord))) {
          TileSetTile? usedTileSetTile = tileSet.findTile(coord);
          TileSetTile tileSetTile =
              usedTileSetTile ??
              TileSetTile(
                id: tileSet.getNextTileId(), //
                coord: coord,
              );

          if (tileSetTile.output != null) {
            OverviewOutputTileComponent? topLeftOutputTile = getOverviewTileComponent(tileSetTile.output!.left - 1, tileSetTile.output!.top - 1);
            if (topLeftOutputTile != null) {
              OverviewTileSetTileComponent singleTileComponent = OverviewTileSetTileComponent(
                projectItem: tileSet,
                tile: tileSetTile,
                originalPosition: topLeftOutputTile.position,
                position: topLeftOutputTile.position,
                external: true,
              );
              placeSilent(topLeftOutputTile, singleTileComponent);
              add(singleTileComponent);
            }
          }
        }
      }
    }
  }

  void initOutputComponents(int atlasMaxX, double outputShiftX) {
    TileSetOutput output = game.project.output;
    int tileWidth = output.tileSize.widthPx;
    int tileHeight = output.tileSize.heightPx;
    int outputWidth = output.size.width;
    int outputHeight = output.size.height;

    addAll(DrawUtils.getRulerComponents(outputWidth, outputHeight, tileWidth, tileHeight, outputShiftX));

    for (int i = 0; i < outputWidth; i++) {
      for (int j = 0; j < outputHeight; j++) {
        OverviewOutputTileComponent outputTile = OverviewOutputTileComponent(
          tileWidth: tileWidth.toDouble(),
          tileHeight: tileHeight.toDouble(),
          atlasX: i,
          atlasY: j,
          position: Vector2(outputShiftX + DrawUtils.ruler.width + i * tileWidth, DrawUtils.ruler.height + j * tileHeight),
        );
        add(outputTile);
        outputTiles.add(outputTile);
      }
    }
  }
}

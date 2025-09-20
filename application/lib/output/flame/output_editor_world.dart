import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/items/tilegroup_file.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/output/tileset_output.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';
import 'package:tileseteditor/output/flame/component/navigation_button_component.dart';
import 'package:tileseteditor/output/flame/component/tilegroup_file_component.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/component/output_tile_component.dart';
import 'package:tileseteditor/output/flame/component/tileset_group_component.dart';
import 'package:tileseteditor/output/flame/component/tileset_tile_component.dart';
import 'package:tileseteditor/output/flame/component/tileset_slice_component.dart';
import 'package:tileseteditor/output/flame/component/yate_component.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class OutputEditorWorld extends World with HasGameReference<OutputEditorGame>, HasCollisionDetection {
  static const int movePriority = 1000;
  static const double dragTolarance = 5;
  static double cameraButtonDim = 20;
  static double cameraButtonSpace = 1;

  YateComponent? selected;
  List<OutputTileComponent> outputTiles = [];

  int _actionKey = -1;

  void setAction(int actionKey) => _actionKey = actionKey;
  int get actionKey => _actionKey;

  OutputEditorWorld();

  void unselect() {
    if (selected != null) {
      select(selected!);
    }
  }

  void select(YateComponent component, {bool force = false}) {
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

  void setSelected(YateComponent component) {
    selected = component;
    game.outputState.yateItem.select(component.getItem());
  }

  bool isSelected(YateComponent component) {
    return selected == component;
  }

  bool canAccept(OutputTileComponent topLeftTile, YateComponent component) {
    bool result = true;
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        OutputTileComponent? tile = getOutputTileComponent(i, j);
        if (tile == null || !tile.canAccept(component)) {
          result = false;
        }
      }
    }
    return result;
  }

  void place(OutputTileComponent topLeftTile, YateComponent component) {
    component.release();
    int numberOfPlacedTiles = 0;
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        OutputTileComponent? tile = getOutputTileComponent(i, j);
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

  void placeSilent(OutputTileComponent topLeftTile, YateComponent component) {
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        OutputTileComponent? tile = getOutputTileComponent(i, j);
        if (tile != null && tile.canAccept(component)) {
          tile.store(component);
        }
      }
    }
  }

  bool moveByKey(int atlasX, int atlasY) {
    bool result = false;
    if (selected != null) {
      OutputTileComponent? newTopLeftOutputTile = getOutputTileComponent(atlasX, atlasY);
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

  OutputTileComponent? getOutputTileComponent(int atlasX, int atlasY) {
    OutputTileComponent? result;
    if (atlasX >= 0 && atlasX < game.project.output.size.width && atlasY >= 0 && atlasY < game.project.output.size.height) {
      result = outputTiles.where((outputTile) => outputTile.atlasX == atlasX && outputTile.atlasY == atlasY).first;
    }
    return result;
  }

  void removeItem(YateItem tileSetItem) {
    if (tileSetItem.output != null) {
      OutputTileComponent? outputTile = getOutputTileComponent(tileSetItem.output!.left - 1, tileSetItem.output!.top - 1);
      if (outputTile != null && outputTile.isUsed()) {
        outputTile.removeStoredTileSetItem();
      }
    }
  }

  void removeAllItems() {
    for (OutputTileComponent outputTile in outputTiles) {
      if (outputTile.isUsed()) {
        outputTile.removeStoredTileSetItem();
      }
    }
    game.project.initOutput();
  }

  @override
  Future<void> onLoad() async {
    TileSet tileSet = game.tileSet;
    TileGroup tileGroup = game.tileGroup;

    int atlasMaxX = 0;
    int atlasMaxY = 0;
    if (tileSet != TileSet.none) {
      atlasMaxX = tileSet.image!.width ~/ tileSet.tileSize.widthPx;
      atlasMaxY = tileSet.image!.height ~/ tileSet.tileSize.heightPx;
    }

    double outputShiftX = getOutputShiftLeft(tileSet, tileGroup, atlasMaxX);
    initOutputComponents(atlasMaxX, outputShiftX);
    if (tileSet != TileSet.none) {
      initCurrentTileSetComponents(tileSet, atlasMaxX, atlasMaxY);
    }
    if (tileGroup != TileGroup.none) {
      initCurrentTileGroupComponents(tileGroup, atlasMaxX);
    }
    initOtherTileSetComponents(tileSet.key);
    initOtherTileGroupComponents(tileGroup, atlasMaxX);
    initButtonsAndCamera();
  }

  void initOtherTileGroupComponents(TileGroup currentTileGroup, int atlasMaxX) {
    for (TileGroup tileGroup in game.project.tileGroups) {
      if (tileGroup.id != currentTileGroup.id) {
        for (TileGroupFile file in tileGroup.files) {
          if (file.output != null) {
            OutputTileComponent? topLeftOutputTile = getOutputTileComponent(file.output!.left - 1, file.output!.top - 1);
            if (topLeftOutputTile != null) {
              TileGroupFileComponent fileComponent = TileGroupFileComponent(
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
  }

  void initCurrentTileGroupComponents(TileGroup tileGroup, int atlasMaxX) {
    int tileWidth = tileGroup.tileSize.widthPx;
    int tileHeight = tileGroup.tileSize.heightPx;
    int fileTopIndex = 0;
    for (TileGroupFile file in tileGroup.files) {
      TileGroupFileComponent fileComponent = TileGroupFileComponent(
        projectItem: tileGroup,
        file: file,
        originalPosition: Vector2(DrawUtils.ruler.width + (atlasMaxX + 1) * tileWidth, DrawUtils.ruler.height + fileTopIndex * tileHeight),
        position: Vector2(DrawUtils.ruler.width + (atlasMaxX + 1) * tileWidth, DrawUtils.ruler.height + fileTopIndex * tileHeight),
        external: false,
      );
      if (file.output != null) {
        OutputTileComponent? topLeftOutputTile = getOutputTileComponent(file.output!.left - 1, file.output!.top - 1);
        if (topLeftOutputTile != null) {
          placeSilent(topLeftOutputTile, fileComponent);
          fileComponent.position = topLeftOutputTile.position;
        }
      }
      add(fileComponent);
      fileTopIndex += file.size.height + 1;
    }
  }

  double getOutputShiftLeft(TileSet tileSet, TileGroup tileGroup, int atlasMaxX) {
    int maxWidth = 0;
    int tileWidthPx = 0;
    if (tileSet != TileSet.none) {
      tileWidthPx = tileSet.tileSize.widthPx;
      for (TileSetGroup group in tileSet.groups) {
        if (group.size.width > maxWidth) {
          maxWidth = group.size.width;
        }
      }
    }
    if (tileGroup != TileGroup.none) {
      tileWidthPx = tileGroup.tileSize.widthPx;
      for (TileGroupFile file in tileGroup.files) {
        if (file.size.width > maxWidth) {
          maxWidth = file.size.width;
        }
      }
    }
    return (atlasMaxX + maxWidth + 1) * tileWidthPx + 50;
  }

  void initOtherTileSetComponents(int currentTileSetKey) {
    for (TileSet tileSet in game.project.tileSets) {
      if (tileSet.key != currentTileSetKey) {
        initOtherTileSetSlices(tileSet);
        initOtherTileSetGroups(tileSet);
        initOtherTileSetTiles(tileSet);
      }
    }
  }

  void initOtherTileSetSlices(TileSet tileSet) {
    for (TileSetSlice slice in tileSet.slices) {
      if (slice.output != null) {
        OutputTileComponent? topLeftOutputTile = getOutputTileComponent(slice.output!.left - 1, slice.output!.top - 1);
        if (topLeftOutputTile != null) {
          TileSetSliceComponent sliceComponent = TileSetSliceComponent(
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
        OutputTileComponent? topLeftOutputTile = getOutputTileComponent(group.output!.left - 1, group.output!.top - 1);
        if (topLeftOutputTile != null) {
          TileSetGroupComponent groupComponent = TileSetGroupComponent(
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
            OutputTileComponent? topLeftOutputTile = getOutputTileComponent(tileSetTile.output!.left - 1, tileSetTile.output!.top - 1);
            if (topLeftOutputTile != null) {
              TileSetTileComponent singleTileComponent = TileSetTileComponent(
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

  void initCurrentTileSetComponents(TileSet tileSet, int atlasMaxX, int atlasMaxY) {
    addAll(DrawUtils.getRulerComponents(atlasMaxX, atlasMaxY, tileSet.tileSize.widthPx, tileSet.tileSize.heightPx, 0));
    initTileSetSlices(tileSet);
    initTileSetGroups(tileSet, atlasMaxX);
    initTileSetTiles(tileSet, atlasMaxX, atlasMaxY);
  }

  void initTileSetSlices(TileSet tileSet) {
    int tileWidth = tileSet.tileSize.widthPx;
    int tileHeight = tileSet.tileSize.heightPx;
    for (TileSetSlice slice in tileSet.slices) {
      TileSetSliceComponent sliceComponent = TileSetSliceComponent(
        projectItem: tileSet,
        slice: slice,
        originalPosition: Vector2(DrawUtils.ruler.width + (slice.coord.left - 1) * tileWidth, DrawUtils.ruler.height + (slice.coord.top - 1) * tileHeight),
        position: Vector2(DrawUtils.ruler.width + (slice.coord.left - 1) * tileWidth, DrawUtils.ruler.height + (slice.coord.top - 1) * tileHeight),
        external: false,
      );
      if (slice.output != null) {
        OutputTileComponent? topLeftOutputTile = getOutputTileComponent(slice.output!.left - 1, slice.output!.top - 1);
        if (topLeftOutputTile != null) {
          placeSilent(topLeftOutputTile, sliceComponent);
          sliceComponent.position = topLeftOutputTile.position;
        }
      }
      add(sliceComponent);
    }
  }

  void initTileSetGroups(TileSet tileSet, int atlasMaxX) {
    int tileWidth = tileSet.tileSize.widthPx;
    int tileHeight = tileSet.tileSize.heightPx;
    int groupTopIndex = 0;
    for (TileSetGroup group in tileSet.groups) {
      TileSetGroupComponent groupComponent = TileSetGroupComponent(
        projectItem: tileSet,
        group: group,
        originalPosition: Vector2(DrawUtils.ruler.width + (atlasMaxX + 1) * tileWidth, DrawUtils.ruler.height + groupTopIndex * tileHeight),
        position: Vector2(DrawUtils.ruler.width + (atlasMaxX + 1) * tileWidth, DrawUtils.ruler.height + groupTopIndex * tileHeight),
        external: false,
      );
      if (group.output != null) {
        OutputTileComponent? topLeftOutputTile = getOutputTileComponent(group.output!.left - 1, group.output!.top - 1);
        if (topLeftOutputTile != null) {
          placeSilent(topLeftOutputTile, groupComponent);
          groupComponent.position = topLeftOutputTile.position;
        }
      }
      add(groupComponent);
      groupTopIndex += group.size.height + 1;
    }
  }

  void initTileSetTiles(TileSet tileSet, int atlasMaxX, int atlasMaxY) {
    int tileWidth = tileSet.tileSize.widthPx;
    int tileHeight = tileSet.tileSize.heightPx;
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
          TileSetTileComponent singleTileComponent = TileSetTileComponent(
            projectItem: tileSet,
            tile: tileSetTile,
            originalPosition: Vector2(DrawUtils.ruler.width + i * tileWidth, DrawUtils.ruler.height + j * tileHeight),
            position: Vector2(DrawUtils.ruler.width + i * tileWidth, DrawUtils.ruler.height + j * tileHeight),
            external: false,
          );
          if (tileSetTile.output != null) {
            OutputTileComponent? topLeftOutputTile = getOutputTileComponent(tileSetTile.output!.left - 1, tileSetTile.output!.top - 1);
            if (topLeftOutputTile != null) {
              placeSilent(topLeftOutputTile, singleTileComponent);
              singleTileComponent.position = topLeftOutputTile.position;
            }
          }
          add(singleTileComponent);
        }
      }
    }
  }

  void initButtonsAndCamera() {
    double upDownButtonHeight = (game.size.y - cameraButtonDim - cameraButtonSpace * 2) / 2 - cameraButtonSpace;
    double leftRightButtonWidth = (game.size.x - cameraButtonSpace * 2) / 2 - cameraButtonSpace;
    final actionCameraUpButton = createButton(
      '⇡',
      Rect.fromLTWH(0, 0, cameraButtonDim, upDownButtonHeight), //
      EdgeInsets.only(right: cameraButtonSpace, top: cameraButtonSpace),
      Anchor.topLeft,
      () {
        game.camera.moveBy(Vector2(0, -1 * OutputEditorGame.scrollUnit));
      },
    );
    final actionCameraDownButton = createButton(
      '⇣',
      Rect.fromLTWH(0, 0, cameraButtonDim, upDownButtonHeight), //
      EdgeInsets.only(right: cameraButtonSpace, bottom: cameraButtonDim + cameraButtonSpace * 2),
      Anchor.bottomLeft,
      () {
        game.camera.moveBy(Vector2(0, OutputEditorGame.scrollUnit));
      },
    );
    final actionCameraLeftButton = createButton(
      '⇠',
      Rect.fromLTWH(0, 0, leftRightButtonWidth, cameraButtonDim), //
      EdgeInsets.only(left: cameraButtonSpace, bottom: cameraButtonSpace),
      Anchor.topLeft,
      () {
        game.camera.moveBy(Vector2(-1 * OutputEditorGame.scrollUnit, 0));
      },
    );
    final actionCameraRightButton = createButton(
      '⇢',
      Rect.fromLTWH(0, 0, leftRightButtonWidth, cameraButtonDim), //
      EdgeInsets.only(right: cameraButtonSpace * 2, bottom: cameraButtonSpace),
      Anchor.bottomLeft,
      () {
        game.camera.moveBy(Vector2(OutputEditorGame.scrollUnit, 0));
      },
    );

    game.camera.viewport.addAll([actionCameraLeftButton, actionCameraRightButton, actionCameraUpButton, actionCameraDownButton]);
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2(0, 0);
  }

  HudButtonComponent createButton(String label, Rect buttonRect, EdgeInsets margin, Anchor anchor, dynamic Function() onPressed) {
    return HudButtonComponent(
      button: NavigationButtonComponent.fromRect(label, buttonRect, paint: DrawUtils.getFillPaint(EditorColor.buttonNormal.color)),
      buttonDown: NavigationButtonComponent.fromRect(label, buttonRect, paint: DrawUtils.getFillPaint(EditorColor.buttonDown.color)),
      margin: margin,
      anchor: anchor,
      onPressed: onPressed,
    );
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
        OutputTileComponent outputTile = OutputTileComponent(
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

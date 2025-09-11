import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/output/tileset_output.dart';
import 'package:tileseteditor/domain/items/tileset_group.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/items/tileset_slice.dart';
import 'package:tileseteditor/domain/items/tileset_tile.dart';
import 'package:tileseteditor/output/tilegroup/flame/tilegroup_output_editor_game.dart';
import 'package:tileseteditor/output/tilegroup/flame/yate_output_tile_component.dart';
import 'package:tileseteditor/output/tilegroup/flame/items/tileset_group_component.dart';
import 'package:tileseteditor/output/tilegroup/flame/items/tileset_single_tile_component.dart';
import 'package:tileseteditor/output/tilegroup/flame/items/tileset_slice_component.dart';
import 'package:tileseteditor/output/tilegroup/flame/items/yate_component.dart';
import 'package:tileseteditor/output/tileset/flame/tileset_output_editor_game.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class TileGroupOutputEditorWorld extends World with HasGameReference<TileGroupOutputEditorGame>, HasCollisionDetection {
  static TextPaint rulerPaint = TextPaint(style: TextStyle(fontSize: 15.0, color: EditorColor.ruler.color));
  static const int movePriority = 1000;
  static const double dragTolarance = 5;
  static double cameraButtonDim = 30;
  static double cameraButtonSpace = 5;

  YateComponent? selected;
  List<YateOutputTileComponent> outputTiles = [];

  int _actionKey = -1;

  void setAction(int actionKey) => _actionKey = actionKey;
  int get actionKey => _actionKey;

  TileGroupOutputEditorWorld();

  void select(YateComponent component, {bool force = false}) {
    if (force) {
      setSelected(component);
    } else {
      if (selected != null) {
        if (selected == component) {
          selected = null;
          game.outputState.tileSetItem.unselect();
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
    game.outputState.tileSetItem.select(component.getTileSetItem());
  }

  bool isSelected(YateComponent component) {
    return selected == component;
  }

  bool canAccept(YateOutputTileComponent topLeftTile, YateComponent component) {
    bool result = true;
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        YateOutputTileComponent? tile = getOutputTileComponent(i, j);
        if (tile == null || !tile.canAccept(component)) {
          result = false;
        }
      }
    }
    return result;
  }

  void place(YateOutputTileComponent topLeftTile, YateComponent component) {
    component.release();
    int numberOfPlacedTiles = 0;
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        YateOutputTileComponent? tile = getOutputTileComponent(i, j);
        if (tile != null && tile.canAccept(component)) {
          tile.store(component);
          numberOfPlacedTiles++;
        }
      }
    }
    if (numberOfPlacedTiles == component.areaSize.width * component.areaSize.height) {
      component.placeOutput(topLeftTile);
      game.outputState.tileSetItem.select(component.getTileSetItem());
    }
  }

  void placeSilent(YateOutputTileComponent topLeftTile, YateComponent component) {
    for (int j = topLeftTile.atlasY; j < topLeftTile.atlasY + component.areaSize.height; j++) {
      for (int i = topLeftTile.atlasX; i < topLeftTile.atlasX + component.areaSize.width; i++) {
        YateOutputTileComponent? tile = getOutputTileComponent(i, j);
        if (tile != null && tile.canAccept(component)) {
          tile.store(component);
        }
      }
    }
  }

  bool moveByKey(int atlasX, int atlasY) {
    bool result = false;
    if (selected != null) {
      YateOutputTileComponent? newTopLeftOutputTile = getOutputTileComponent(atlasX, atlasY);
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

  YateOutputTileComponent? getOutputTileComponent(int atlasX, int atlasY) {
    YateOutputTileComponent? result;
    if (atlasX >= 0 && atlasX < game.project.output.size.width && atlasY >= 0 && atlasY < game.project.output.size.height) {
      result = outputTiles.where((outputTile) => outputTile.atlasX == atlasX && outputTile.atlasY == atlasY).first;
    }
    return result;
  }

  void removeTileSetItem(YateItem tileSetItem) {
    if (tileSetItem.output != null) {
      YateOutputTileComponent? outputTile = getOutputTileComponent(tileSetItem.output!.left - 1, tileSetItem.output!.top - 1);
      if (outputTile != null && outputTile.isUsed()) {
        outputTile.removeStoredTileSetItem();
      }
    }
  }

  void removeAllTileSetItem() {
    for (YateOutputTileComponent outputTile in outputTiles) {
      if (outputTile.isUsed()) {
        outputTile.removeStoredTileSetItem();
      }
    }
    game.project.initOutput();
  }

  @override
  Future<void> onLoad() async {
    TileGroup tileGroup = game.tileGroup;
    int atlasMaxX = 0; // tileSet.image!.width ~/ tileSet.tileSize.widthPx;
    int atlasMaxY = 0; // tileSet.image!.height ~/ tileSet.tileSize.heightPx;

    double outputShiftX = getOutputShiftLeft(tileGroup, atlasMaxX);
    initOutputComponents(atlasMaxX, outputShiftX);
    // initTgTileSetComponents(tileSet, atlasMaxX, atlasMaxY);
    initOtherTgTileSetComponents(-1);
    initButtonsAndCamera();
  }

  double getOutputShiftLeft(TileGroup tileGroup, int atlasMaxX) {
    /* FIXME calc shift
    int maxGroupWidth = 0;
    for (TileSetGroup group in tileSet.groups) {
      if (group.size.width > maxGroupWidth) {
        maxGroupWidth = group.size.width;
      }
    }
    double outputShiftX = (atlasMaxX + maxGroupWidth + 1) * tileSet.tileSize.widthPx + 50;
    */
    return 0; //outputShiftX;
  }

  void initOtherTgTileSetComponents(int currentTileSetKey) {
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
        YateOutputTileComponent? topLeftOutputTile = getOutputTileComponent(slice.output!.left - 1, slice.output!.top - 1);
        if (topLeftOutputTile != null) {
          TileSetSliceComponent sliceComponent = TileSetSliceComponent(
            tileSet: tileSet,
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
        YateOutputTileComponent? topLeftOutputTile = getOutputTileComponent(group.output!.left - 1, group.output!.top - 1);
        if (topLeftOutputTile != null) {
          TileSetGroupComponent groupComponent = TileSetGroupComponent(
            tileSet: tileSet,
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
            YateOutputTileComponent? topLeftOutputTile = getOutputTileComponent(tileSetTile.output!.left - 1, tileSetTile.output!.top - 1);
            if (topLeftOutputTile != null) {
              TileSetSingleTileComponent singleTileComponent = TileSetSingleTileComponent(
                tileSet: tileSet,
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

  void initButtonsAndCamera() {
    double upDownButtonHeight = (game.size.y - cameraButtonDim - cameraButtonSpace * 2) / 2 - cameraButtonSpace;
    double leftRightButtonWidth = (game.size.x - cameraButtonDim - cameraButtonSpace * 2) / 2 - cameraButtonSpace;
    final actionCameraUpButton = createButton(
      Rect.fromLTWH(0, 0, cameraButtonDim, upDownButtonHeight), //
      EdgeInsets.only(right: cameraButtonSpace, top: cameraButtonSpace),
      Anchor.topLeft,
      () {
        game.camera.moveBy(Vector2(0, -1 * TileSetOutputEditorGame.scrollUnit));
      },
    );
    final actionCameraDownButton = createButton(
      Rect.fromLTWH(0, 0, cameraButtonDim, upDownButtonHeight), //
      EdgeInsets.only(right: cameraButtonSpace, bottom: cameraButtonDim + cameraButtonSpace * 2),
      Anchor.bottomLeft,
      () {
        game.camera.moveBy(Vector2(0, TileSetOutputEditorGame.scrollUnit));
      },
    );
    final actionCameraLeftButton = createButton(
      Rect.fromLTWH(0, 0, leftRightButtonWidth, cameraButtonDim), //
      EdgeInsets.only(left: cameraButtonSpace, bottom: cameraButtonSpace),
      Anchor.topLeft,
      () {
        game.camera.moveBy(Vector2(-1 * TileSetOutputEditorGame.scrollUnit, 0));
      },
    );
    final actionCameraRightButton = createButton(
      Rect.fromLTWH(0, 0, leftRightButtonWidth, cameraButtonDim), //
      EdgeInsets.only(right: cameraButtonDim + cameraButtonSpace * 2, bottom: cameraButtonSpace),
      Anchor.bottomLeft,
      () {
        game.camera.moveBy(Vector2(TileSetOutputEditorGame.scrollUnit, 0));
      },
    );

    game.camera.viewport.addAll([actionCameraLeftButton, actionCameraRightButton, actionCameraUpButton, actionCameraDownButton]);
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2(0, 0);
  }

  HudButtonComponent createButton(Rect buttonRect, EdgeInsets margin, Anchor anchor, dynamic Function() onPressed) {
    return HudButtonComponent(
      button: RectangleComponent.fromRect(buttonRect, paint: DrawUtils.getFillPaint(EditorColor.buttonNormal.color)),
      buttonDown: RectangleComponent.fromRect(buttonRect, paint: DrawUtils.getFillPaint(EditorColor.buttonDown.color)),
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

    initOutputRuler(outputWidth, outputHeight, tileWidth, tileHeight, outputShiftX);

    for (int i = 0; i < outputWidth; i++) {
      for (int j = 0; j < outputHeight; j++) {
        YateOutputTileComponent outputTile = YateOutputTileComponent(
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

  void initOutputRuler(int outputWidth, int outputHeight, int outputTileWidth, int outputTileHeight, double outputShiftX) {
    for (int column = 1; column <= outputWidth; column++) {
      add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$column',
          position: Vector2(outputShiftX + DrawUtils.ruler.width + (column - 1) * outputTileWidth + 12, 0),
          size: Vector2(outputTileWidth.toDouble(), DrawUtils.ruler.height),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }
    for (int row = 1; row <= outputHeight; row++) {
      add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$row',
          position: Vector2(outputShiftX, DrawUtils.ruler.height + (row - 1) * outputTileHeight + 6),
          size: Vector2(DrawUtils.ruler.width, outputTileHeight.toDouble()),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }
  }
}

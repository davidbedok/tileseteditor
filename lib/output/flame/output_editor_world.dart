import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/output/flame/tileset/group_component.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/flame/tileset/tileset_component.dart';
import 'package:tileseteditor/output/flame/tileset/single_tile_component.dart';
import 'package:tileseteditor/output/flame/tileset/slice_component.dart';

class OutputEditorWorld extends World with HasGameReference<OutputEditorGame>, HasCollisionDetection {
  static const int movePriority = 1000;
  static const double dragTolarance = 5;

  TileSetComponent? selected;

  List<OutputTileComponent> outputTiles = [];

  dui.Image? image;

  int _actionKey = -1;

  static final Size ruler = Size(20, 20);

  OutputEditorWorld({required this.image});

  int get actionKey => _actionKey;

  void select(TileSetComponent component, {bool force = false}) {
    if (force) {
      selected = component;
    } else {
      if (selected != null) {
        if (selected == component) {
          selected = null;
        } else {
          selected = component;
        }
      } else {
        selected = component;
      }
    }
  }

  bool isSelected(TileSetComponent component) {
    return selected == component;
  }

  bool canAccept(OutputTileComponent topLeftTile, TileSetComponent component) {
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

  void place(OutputTileComponent topLeftTile, TileSetComponent component) {
    component.release();
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
    if (atlasX >= 0 && atlasX < game.project.output.width && atlasY >= 0 && atlasY < game.project.output.height) {
      result = outputTiles.where((outputTile) => outputTile.atlasX == atlasX && outputTile.atlasY == atlasY).first;
    }
    return result;
  }

  TextPaint rulerPaint = TextPaint(style: TextStyle(fontSize: 15.0, color: BasicPalette.black.color));

  void setAction(int actionKey) {
    _actionKey = actionKey;
  }

  static Paint getBorderPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  @override
  Future<void> onLoad() async {
    int tileWidth = game.tileSet.tileWidth;
    int tileHeight = game.tileSet.tileHeight;

    int atlasMaxX = image!.width ~/ tileWidth;
    int atlasMaxY = image!.height ~/ tileHeight;

    for (int column = 1; column <= atlasMaxX; column++) {
      add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$column',
          position: Vector2(ruler.width + (column - 1) * tileWidth + 12, 0),
          size: Vector2(tileWidth.toDouble(), ruler.height),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }
    for (int row = 1; row <= atlasMaxY; row++) {
      add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$row',
          position: Vector2(0, ruler.height + (row - 1) * tileHeight + 6),
          size: Vector2(ruler.width, tileHeight.toDouble()),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }

    for (TileSetSlice slice in game.tileSet.slices) {
      add(
        SliceComponent(
          tileSetImage: image!,
          slice: slice,
          tileWidth: tileWidth.toDouble(),
          tileHeight: tileHeight.toDouble(),
          position: Vector2(ruler.width + (slice.left - 1) * tileWidth, ruler.height + (slice.top - 1) * tileHeight),
        ),
      );
    }

    int maxGroupWidth = 0;
    int groupTopIndex = 0;
    for (TileSetGroup group in game.tileSet.groups) {
      if (group.size.width > maxGroupWidth) {
        maxGroupWidth = group.size.width;
      }

      add(
        GroupComponent(
          tileSetImage: image!,
          group: group,
          tileWidth: tileWidth.toDouble(),
          tileHeight: tileHeight.toDouble(),
          position: Vector2(ruler.width + (atlasMaxX + 1) * tileWidth, ruler.height + groupTopIndex * tileHeight),
        ),
      );
      groupTopIndex += group.size.height + 1;
    }

    for (int i = 0; i < atlasMaxX; i++) {
      for (int j = 0; j < atlasMaxY; j++) {
        if (game.tileSet.isFree(game.tileSet.getIndex(TileCoord(i + 1, j + 1)))) {
          add(
            SingleTileComponent(
              tileSetImage: image!,
              tileWidth: tileWidth.toDouble(),
              tileHeight: tileHeight.toDouble(),
              atlasX: i,
              atlasY: j,
              position: Vector2(ruler.width + i * tileWidth, ruler.height + j * tileHeight),
            ),
          );
        }
      }
    }

    double outputShiftX = (atlasMaxX + maxGroupWidth + 1) * tileWidth + 50;

    int outputTileWidth = game.project.output.tileWidth;
    int outputTileHeight = game.project.output.tileHeight;
    int outputWidth = game.project.output.width;
    int outputHeight = game.project.output.height;

    for (int column = 1; column <= outputWidth; column++) {
      add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$column',
          position: Vector2(outputShiftX + ruler.width + (column - 1) * outputTileWidth + 12, 0),
          size: Vector2(outputTileWidth.toDouble(), ruler.height),
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
          position: Vector2(outputShiftX, ruler.height + (row - 1) * outputTileHeight + 6),
          size: Vector2(ruler.width, outputTileHeight.toDouble()),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }

    for (int i = 0; i < outputWidth; i++) {
      for (int j = 0; j < outputHeight; j++) {
        OutputTileComponent outputTile = OutputTileComponent(
          tileSetImage: image!,
          tileWidth: outputTileWidth.toDouble(),
          tileHeight: outputTileHeight.toDouble(),
          atlasX: i,
          atlasY: j,
          position: Vector2(outputShiftX + ruler.width + i * outputTileWidth, ruler.height + j * outputTileHeight),
        );
        add(outputTile);
        outputTiles.add(outputTile);
      }
    }

    double cameraButtonDim = 30;
    double upDownButtonHeight = (game.size.y - cameraButtonDim - 10) / 2 - 5;
    Rect actionCameraUpRect = Rect.fromLTWH(0, 0, cameraButtonDim, upDownButtonHeight);
    Paint buttonNormalPaint = BasicPalette.gray.withAlpha(200).paint();
    Paint buttonDownPaint = BasicPalette.darkGreen.withAlpha(200).paint();
    final actionCameraUpButton = HudButtonComponent(
      button: RectangleComponent.fromRect(actionCameraUpRect, paint: buttonNormalPaint),
      buttonDown: RectangleComponent.fromRect(actionCameraUpRect, paint: buttonDownPaint),
      margin: const EdgeInsets.only(right: 5, top: 5),
      anchor: Anchor.topLeft,
      onPressed: () {
        game.camera.moveBy(Vector2(0, -1 * OutputEditorGame.scrollUnit));
      },
    );

    Rect actionCameraDownRect = Rect.fromLTWH(0, 0, cameraButtonDim, upDownButtonHeight);
    final actionCameraDownButton = HudButtonComponent(
      button: RectangleComponent.fromRect(actionCameraDownRect, paint: buttonNormalPaint),
      buttonDown: RectangleComponent.fromRect(actionCameraDownRect, paint: buttonDownPaint),
      margin: const EdgeInsets.only(right: 5, bottom: 40),
      anchor: Anchor.bottomLeft,
      onPressed: () {
        game.camera.moveBy(Vector2(0, OutputEditorGame.scrollUnit));
      },
    );

    double leftRightButtonWidth = (game.size.x - cameraButtonDim - 10) / 2 - 5;
    Rect actionCameraLeftRect = Rect.fromLTWH(0, 0, leftRightButtonWidth, 30);
    final actionCameraLeftButton = HudButtonComponent(
      button: RectangleComponent.fromRect(actionCameraLeftRect, paint: buttonNormalPaint),
      buttonDown: RectangleComponent.fromRect(actionCameraLeftRect, paint: buttonDownPaint),
      margin: const EdgeInsets.only(left: 5, bottom: 5),
      anchor: Anchor.topLeft,
      onPressed: () {
        game.camera.moveBy(Vector2(-1 * OutputEditorGame.scrollUnit, 0));
      },
    );

    Rect actionCameraRightRect = Rect.fromLTWH(0, 0, leftRightButtonWidth, cameraButtonDim);
    final actionCameraRightButton = HudButtonComponent(
      button: RectangleComponent.fromRect(actionCameraRightRect, paint: buttonNormalPaint),
      buttonDown: RectangleComponent.fromRect(actionCameraRightRect, paint: buttonDownPaint),
      margin: const EdgeInsets.only(right: 40, bottom: 5),
      anchor: Anchor.bottomLeft,
      onPressed: () {
        game.camera.moveBy(Vector2(OutputEditorGame.scrollUnit, 0));
      },
    );

    game.camera.viewport.addAll([actionCameraLeftButton, actionCameraRightButton, actionCameraUpButton, actionCameraDownButton]);

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2(0, 0);
  }
}

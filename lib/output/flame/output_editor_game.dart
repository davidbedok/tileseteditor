import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tileset.dart';
import 'package:tileseteditor/domain/tileset_project.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/output/flame/output_editor_world.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/state/output_editor_state.dart';

class OutputEditorGame extends FlameGame<OutputEditorWorld> with ScrollDetector, KeyboardEvents {
  static const scrollUnit = 50.0;
  static const zoomPerScrollUnit = 0.02;

  late double startZoom;
  TileSetProject project;
  TileSet tileSet;

  OutputEditorState outputState;

  OutputEditorGame({
    required this.project, //
    required this.tileSet,
    required double width,
    required double height,
    required dui.Image? tileSetImage,
    required this.outputState,
  }) : super(
         world: OutputEditorWorld(image: tileSetImage),
         camera: CameraComponent.withFixedResolution(width: width, height: height),
       ) {
    outputState.subscribeOnRemoved(removeTileSetItem);
  }

  void removeTileSetItem(TileSetItem tileSetItem) {
    world.removeTileSetItem(tileSetItem);
  }

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {}

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.05, 3.0);
  }

  void zoomIn() {
    camera.viewfinder.zoom += 10 * zoomPerScrollUnit;
    clampZoom();
  }

  void zoomOut() {
    if (camera.viewfinder.zoom - 10 * zoomPerScrollUnit > 0) {
      camera.viewfinder.zoom -= 10 * zoomPerScrollUnit;
      clampZoom();
    }
  }

  @override
  void onScroll(PointerScrollInfo info) {
    camera.viewfinder.zoom += info.scrollDelta.global.y.sign * zoomPerScrollUnit;
    clampZoom();
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    KeyEventResult result = KeyEventResult.ignored;
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      camera.moveBy(Vector2(-1 * scrollUnit * 2, 0));
      result = KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      camera.moveBy(Vector2(scrollUnit * 2, 0));
      result = KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyW)) {
      camera.moveBy(Vector2(0, -1 * scrollUnit * 2));
      result = KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
      camera.moveBy(Vector2(0, scrollUnit * 2));
      result = KeyEventResult.handled;
    }
    if (world.selected != null && world.selected!.isPlaced()) {
      OutputTileComponent? topLeftOutputTile = world.selected!.getTopLeftOutputTile();
      if (topLeftOutputTile != null) {
        if (event is KeyDownEvent || event is KeyRepeatEvent) {
          if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
            if (world.moveByKey(topLeftOutputTile.atlasX - 1, topLeftOutputTile.atlasY)) {
              result = KeyEventResult.handled;
            }
          } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
            if (world.moveByKey(topLeftOutputTile.atlasX + 1, topLeftOutputTile.atlasY)) {
              result = KeyEventResult.handled;
            }
          } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
            if (world.moveByKey(topLeftOutputTile.atlasX, topLeftOutputTile.atlasY - 1)) {
              result = KeyEventResult.handled;
            }
          } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
            if (world.moveByKey(topLeftOutputTile.atlasX, topLeftOutputTile.atlasY + 1)) {
              result = KeyEventResult.handled;
            }
          }
        }
      }
    } else {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        camera.moveBy(Vector2(-1 * scrollUnit, 0));
        result = KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        camera.moveBy(Vector2(scrollUnit, 0));
        result = KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        camera.moveBy(Vector2(0, -1 * scrollUnit));
        result = KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        camera.moveBy(Vector2(0, scrollUnit));
        result = KeyEventResult.handled;
      }
    }
    return result;
  }
}

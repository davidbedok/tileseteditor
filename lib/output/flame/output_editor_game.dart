import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/output/flame/output_editor_world.dart';
import 'package:tileseteditor/output/flame/component/output_tile_component.dart';
import 'package:tileseteditor/output/output_state.dart';

class OutputEditorGame extends FlameGame<OutputEditorWorld> with ScrollDetector, KeyboardEvents {
  static const scrollUnit = 50.0;
  static const zoomPerScrollUnit = 0.02;

  late double startZoom;
  YateProject project;
  TileSet tileSet;
  TileGroup tileGroup;
  OutputState outputState;

  OutputEditorGame({
    required this.project, //
    required this.tileSet,
    required this.tileGroup,
    required double width,
    required double height,
    required this.outputState,
  }) : super(
         world: OutputEditorWorld(),
         camera: CameraComponent.withFixedResolution(width: width, height: height),
       ) {
    outputState.yateItem.subscribeRemoval(removeItem);
    outputState.removeAll.subscribe(removeAllItems);
  }

  @override
  void onRemove() {
    outputState.yateItem.unsubscribeRemoval(removeItem);
    outputState.removeAll.unsubscribe(removeAllItems);
  }

  void removeItem(OutputState outputState, YateItem tileSetItem) {
    world.removeItem(tileSetItem);
  }

  void removeAllItems(OutputState outputState) {
    world.removeAllItems();
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
        if (event is KeyDownEvent) {
          if (keysPressed.contains(LogicalKeyboardKey.delete)) {
            world.removeItem(world.selected!.getItem());
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

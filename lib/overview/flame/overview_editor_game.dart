import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/overview/flame/overview_editor_world.dart';
import 'package:tileseteditor/overview/flame/component/overview_output_tile_component.dart';
import 'package:tileseteditor/overview/overview_state.dart';

class OverviewEditorGame extends FlameGame<OverviewEditorWorld> with ScrollDetector, ScaleDetector, KeyboardEvents {
  static const scrollUnit = 50.0;
  static const zoomPerScrollUnit = 0.02;

  late double startZoom;
  YateProject project;

  OverviewState overviewState;

  OverviewEditorGame({
    required this.project, //
    required double width,
    required double height,
    required this.overviewState,
  }) : super(
         world: OverviewEditorWorld(),
         camera: CameraComponent.withFixedResolution(width: width, height: height),
       ) {
    overviewState.tileSetItem.subscribeRemoval(removeTileSetItem);
    overviewState.removeAll.subscribe(removeAllTileSetItem);
  }

  @override
  void onRemove() {
    overviewState.tileSetItem.unsubscribeRemoval(removeTileSetItem);
    overviewState.removeAll.unsubscribe(removeAllTileSetItem);
  }

  void removeTileSetItem(OverviewState state, YateItem tileSetItem) {
    world.removeTileSetItem(tileSetItem);
  }

  void removeAllTileSetItem(OverviewState state) {
    world.removeAllTileSetItem();
  }

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {}

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.05, 3.0);
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
      OverviewOutputTileComponent? topLeftOutputTile = world.selected!.getTopLeftOutputTile();
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
            world.removeTileSetItem(world.selected!.getItem());
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

  @override
  void onScaleStart(_) {
    startZoom = camera.viewfinder.zoom;
  }

  @override
  void onScaleUpdate(ScaleUpdateInfo info) {
    final currentScale = info.scale.global;
    if (!currentScale.isIdentity()) {
      camera.viewfinder.zoom = startZoom * currentScale.y;
      clampZoom();
    } else {
      final zoom = camera.viewfinder.zoom;
      final delta = (info.delta.global..negate()) / zoom;
      camera.moveBy(delta);
    }
  }
}

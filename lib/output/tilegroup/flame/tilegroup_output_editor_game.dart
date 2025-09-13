import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tilegroup/tilegroup.dart';
import 'package:tileseteditor/domain/project.dart';
import 'package:tileseteditor/domain/items/yate_item.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/output/tilegroup/flame/tilegroup_output_editor_world.dart';
import 'package:tileseteditor/output/tilegroup/flame/yate_output_tile_component.dart';
import 'package:tileseteditor/output/tilegroup/tilegroup_output_state.dart';
import 'package:tileseteditor/output/tileset/tileset_output_state.dart';

class TileGroupOutputEditorGame extends FlameGame<TileGroupOutputEditorWorld> with ScrollDetector, KeyboardEvents {
  static const scrollUnit = 50.0;
  static const zoomPerScrollUnit = 0.02;

  late double startZoom;
  TileSetProject project;
  TileSet tileSet;
  TileGroup tileGroup;

  TileSetOutputState? tileSetOutputState;
  TileGroupOutputState? tileGroupOutputState;

  TileGroupOutputEditorGame({
    required this.project, //
    required this.tileSet,
    required this.tileGroup,
    required double width,
    required double height,
    required this.tileSetOutputState,
    required this.tileGroupOutputState,
  }) : super(
         world: TileGroupOutputEditorWorld(),
         camera: CameraComponent.withFixedResolution(width: width, height: height),
       ) {
    // FIXME generalize output..
    if (tileSetOutputState != null) {
      tileSetOutputState!.yateItem.subscribeRemoval(removeTileSetItem);
      tileSetOutputState!.removeAll.subscribe(removeAllTileSetItem);
    }
    if (tileGroupOutputState != null) {
      tileGroupOutputState!.yateItem.subscribeRemoval(removeTileGroupItem);
      tileGroupOutputState!.removeAll.subscribe(removeAllTileGroupItem);
    }
  }

  @override
  void onRemove() {
    if (tileSetOutputState != null) {
      tileSetOutputState!.yateItem.unsubscribeRemoval(removeTileSetItem);
      tileSetOutputState!.removeAll.unsubscribe(removeAllTileSetItem);
    }
    if (tileGroupOutputState != null) {
      tileGroupOutputState!.yateItem.unsubscribeRemoval(removeTileGroupItem);
      tileGroupOutputState!.removeAll.unsubscribe(removeAllTileGroupItem);
    }
  }

  void removeTileSetItem(TileSetOutputState outputState, YateItem tileSetItem) {
    world.removeTileSetItem(tileSetItem);
  }

  void removeAllTileSetItem(TileSetOutputState outputState) {
    world.removeAllTileSetItem();
  }

  void removeTileGroupItem(TileGroupOutputState outputState, YateItem tileSetItem) {
    world.removeTileSetItem(tileSetItem);
  }

  void removeAllTileGroupItem(TileGroupOutputState outputState) {
    world.removeAllTileSetItem();
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
      YateOutputTileComponent? topLeftOutputTile = world.selected!.getTopLeftOutputTile();
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
            world.removeTileSetItem(world.selected!.getTileSetItem());
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

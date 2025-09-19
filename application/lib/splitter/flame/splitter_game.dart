import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/splitter/flame/splitter_world.dart';
import 'package:tileseteditor/splitter/splitter_state.dart';

class SplitterGame extends FlameGame<SplitterWorld> with ScrollDetector, ScaleDetector, KeyboardEvents {
  static const scrollUnit = 50.0;
  static const zoomPerScrollUnit = 0.02;

  late double startZoom;
  TileSet tileSet;
  SplitterState splitterState;

  SplitterGame({required this.tileSet, required double width, required double height, required this.splitterState})
    : super(
        world: SplitterWorld(),
        camera: CameraComponent.withFixedResolution(width: width, height: height),
      );

  @override
  Color backgroundColor() => Colors.white;

  @override
  Future<void> onLoad() async {
    // await images.loadAll(['magecity.png']);
  }

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

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    KeyEventResult result = KeyEventResult.ignored;
    if (keysPressed.contains(LogicalKeyboardKey.keyA) || keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      camera.moveBy(Vector2(-1 * scrollUnit * 2, 0));
      result = KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyD) || keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      camera.moveBy(Vector2(scrollUnit * 2, 0));
      result = KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyW) || keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
      camera.moveBy(Vector2(0, -1 * scrollUnit * 2));
      result = KeyEventResult.handled;
    } else if (keysPressed.contains(LogicalKeyboardKey.keyS) || keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
      camera.moveBy(Vector2(0, scrollUnit * 2));
      result = KeyEventResult.handled;
    }
    return result;
  }
}

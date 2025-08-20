import 'dart:ui' as dui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/flame/editor_world.dart';

class EditorGame extends FlameGame<EditorWorld> with ScrollDetector, ScaleDetector {
  static const zoomPerScrollUnit = 0.02;

  late double startZoom;

  EditorGame({required double width, required double height, required dui.Image? tileSetImage})
    : super(
        world: EditorWorld(image: tileSetImage),
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
}

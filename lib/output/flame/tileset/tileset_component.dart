import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/tileset_area_size.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/output_editor_world.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/flame/tile_move_effect.dart';

class TileSetComponent extends SpriteComponent with HasGameReference<OutputEditorGame>, DragCallbacks, TapCallbacks, HoverCallbacks {
  TileSetAreaSize areaSize;

  List<OutputTileComponent> reservedTiles = [];

  double tileWidth;
  double tileHeight;

  bool isDragging = false;
  Vector2 dragWhereStarted = Vector2(0, 0);

  TileSetComponent({required super.position, required this.tileWidth, required this.tileHeight, required this.areaSize}) {
    priority = 0;
  }

  @override
  void onTapUp(TapUpEvent event) {
    //
  }

  void place(OutputTileComponent outputTile) {
    if (reservedTiles.contains(outputTile)) {
      reservedTiles.add(outputTile);
    }
  }

  void release() {
    for (OutputTileComponent outputTile in reservedTiles) {
      outputTile.empty();
    }
    reservedTiles.clear();
  }

  static Paint getSelectionPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  @override
  void update(double dt) {
    if (isHovered) {
      priority = 100;
    } else {
      priority = 0;
    }
  }

  void doMove(
    Vector2 to, {
    double speed = 10.0,
    double start = 0.0,
    bool keepPriority = false,
    int additionalPriority = 0,
    Curve curve = Curves.easeOutQuad,
    VoidCallback? onComplete,
  }) {
    final dt = (to - position).length / (speed * size.x);
    if (dt > 0) {
      add(
        TileMoveEffect(
          to,
          EffectController(duration: dt, startDelay: start, curve: curve),
          keepPriority: keepPriority,
          additionalPriority: additionalPriority,
          onComplete: () {
            onComplete?.call();
          },
        ),
      );
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (game.world.actionKey < 0) {
      super.onDragStart(event);
      game.world.setAction(event.pointerId);
      dragWhereStarted = position.clone();

      isDragging = true;
      priority = OutputEditorWorld.movePriority;
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (game.world.actionKey == event.pointerId) {
      if (!isDragging) {
        return;
      }
      final delta = event.localDelta;
      position.add(delta);
    }
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (game.world.actionKey == event.pointerId) {
      super.onDragEnd(event);
      if (!isDragging) {
        game.world.setAction(-1);
        return;
      }
      isDragging = false;

      final shortDrag = (position - dragWhereStarted).length < OutputEditorWorld.dragTolarance;
      if (shortDrag) {
        moveToPlace(dragWhereStarted);
        return;
      }

      var dropOutputTile = parent!.componentsAtPoint(position).whereType<OutputTileComponent>().toList();
      if (dropOutputTile.isNotEmpty) {
        if (game.world.canAccept(dropOutputTile.first, this)) {
          final dropPosition = dropOutputTile.first.position;
          doMove(
            dropPosition,
            speed: 15,
            onComplete: () {
              game.world.place(dropOutputTile.first, this);
              game.world.setAction(-1);
            },
          );
        } else {
          moveToPlace(dragWhereStarted);
          return;
        }
        game.world.setAction(-1);
        return;
      }

      moveToPlace(dragWhereStarted);
    }
  }

  void moveToPlace(Vector2 place) {
    doMove(
      place,
      speed: 15.0,
      onComplete: () {
        priority = 0;
        game.world.setAction(-1);
      },
    );
  }
}

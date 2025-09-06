import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/domain/tile_rect_size.dart';
import 'package:tileseteditor/domain/tilesetitem/tileset_item.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/output_editor_world.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/flame/tile_move_effect.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

abstract class TileSetComponent extends SpriteComponent with HasGameReference<OutputEditorGame>, DragCallbacks, TapCallbacks, HoverCallbacks {
  TileSet tileSet;
  TileSetItem tileSetItem;
  Vector2 originalPosition;
  TileRectSize areaSize;
  bool external;

  double tileWidth;
  double tileHeight;

  List<OutputTileComponent> reservedTiles = [];
  bool isDragging = false;
  Vector2 dragWhereStarted = Vector2(0, 0);

  Rect getRect() => Rect.fromLTWH(0, 0, size.x, size.y);
  bool isPlaced() => reservedTiles.isNotEmpty;
  OutputTileComponent? getTopLeftOutputTile() => reservedTiles.isNotEmpty ? reservedTiles.first : null;
  TileSetItem getTileSetItem() => tileSetItem;

  TileSetComponent({
    required super.position,
    required this.tileSet,
    required this.tileSetItem,
    required this.originalPosition,
    required this.areaSize,
    required this.external,
  }) : tileWidth = tileSet.tileSize.widthPx.toDouble(),
       tileHeight = tileSet.tileSize.heightPx.toDouble() {
    priority = 0;
  }

  void removeFromOutput() {
    release();
    if (external) {
      removeFromParent();
    } else {
      moveToPlace(originalPosition);
    }
  }

  void release() {
    tileSetItem.output = null;
    for (OutputTileComponent outputTile in reservedTiles) {
      outputTile.empty();
    }
    reservedTiles.clear();
  }

  void place(OutputTileComponent outputTile) {
    if (reservedTiles.contains(outputTile)) {
      reservedTiles.add(outputTile);
    }
  }

  void placeOutput(OutputTileComponent topLeftTile) {
    tileSetItem.output = topLeftTile.getCoord();
  }

  void doMove(
    Vector2 to, { //
    double speed = 10.0,
    double start = 0.0,
    Curve curve = Curves.easeOutQuad,
    VoidCallback? onComplete,
  }) {
    final dt = (to - position).length / (speed * size.x);
    if (dt > 0) {
      add(
        TileMoveEffect(
          to,
          EffectController(duration: dt, startDelay: start, curve: curve),
          onComplete: () {
            onComplete?.call();
          },
        ),
      );
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

  @override
  void onTapUp(TapUpEvent event) {
    game.world.select(this);
  }

  @override
  void update(double dt) {
    if (isHovered) {
      priority = 100;
    } else {
      priority = 0;
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
      game.world.select(this, force: true);
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

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (game.world.isSelected(this)) {
      canvas.drawRect(getRect(), DrawUtils.getFillPaint(external ? EditorColor.selectedExternalFill.color : EditorColor.selectedFill.color, alpha: 100));
    }
    if (isHovered) {
      canvas.drawRect(getRect(), DrawUtils.getBorderPaint(external ? EditorColor.hoverExternalBorder.color : EditorColor.hoverBorder.color, 2.0));
      drawInfo(canvas);
    }
  }

  void drawInfo(Canvas canvas) {
    var textSpan = TextSpan(
      text: '${external ? '${tileSet.name}\n' : ''}${tileSetItem.getLabel()}',
      style: TextStyle(color: tileSetItem.getTextColor(), fontWeight: FontWeight.bold),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: 200);
    textPainter.paint(canvas, Offset(0, external ? -40 : -20));
  }
}

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/overview/flame/overview_editor_game.dart';
import 'package:tileseteditor/overview/flame/tileset/overview_tileset_component.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class OverviewTileComponent extends PositionComponent with HasGameReference<OverviewEditorGame>, HoverCallbacks {
  double tileWidth;
  double tileHeight;

  int atlasX;
  int atlasY;

  OverviewTileSetComponent? _storedTile;

  TileCoord getCoord() => TileCoord(atlasX + 1, atlasY + 1);
  bool canAccept(OverviewTileSetComponent tile) => isFree() || tile == _storedTile;
  bool isFree() => _storedTile == null;
  bool isUsed() => _storedTile != null;
  Rect getRect() => Rect.fromLTWH(0, 0, tileWidth, tileHeight);

  OverviewTileComponent({
    required this.tileWidth, //
    required this.tileHeight,
    required this.atlasX,
    required this.atlasY,
    required super.position,
  }) {
    priority = 0;
  }

  void store(OverviewTileSetComponent tile) {
    _storedTile = tile;
    tile.reservedTiles.add(this);
  }

  void empty() {
    _storedTile = null;
  }

  void removeStoredTileSetItem() {
    if (_storedTile != null) {
      _storedTile!.removeFromOutput();
    }
    empty();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(tileWidth, tileHeight);
    // debugMode = true;
  }

  @override
  void update(double dt) {
    if (isHovered) {
      priority = 200;
    } else {
      priority = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(getRect(), DrawUtils.getBorderPaint(EditorColor.tile.color, 1.0));

    if (isHovered) {
      canvas.drawRect(getRect(), DrawUtils.getBorderPaint(EditorColor.tileHovered.color, 2.0));
    }
  }
}

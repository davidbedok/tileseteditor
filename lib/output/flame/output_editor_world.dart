import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tileset_group.dart';
import 'package:tileseteditor/domain/tileset_slice.dart';
import 'package:tileseteditor/output/flame/group_component.dart';
import 'package:tileseteditor/output/flame/output_editor_game.dart';
import 'package:tileseteditor/output/flame/output_tile_component.dart';
import 'package:tileseteditor/output/flame/single_tile_component.dart';
import 'package:tileseteditor/output/flame/slice_component.dart';
import 'package:tileseteditor/splitter/flame/example_component.dart';

class OutputEditorWorld extends World with HasGameReference<OutputEditorGame>, HasCollisionDetection {
  static const int movePriority = 1000;
  static const double dragTolarance = 5;

  Image? image;

  int _actionKey = -1;

  static final Size ruler = Size(20, 20);

  OutputEditorWorld({required this.image});

  int get actionKey => _actionKey;

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
    if (image == null) {
      add(ExampleComponent(position: Vector2(0, 0)));
    } else {
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
          add(
            OutputTileComponent(
              tileSetImage: image!,
              tileWidth: outputTileWidth.toDouble(),
              tileHeight: outputTileHeight.toDouble(),
              atlasX: i,
              atlasY: j,
              position: Vector2(outputShiftX + ruler.width + i * outputTileWidth, ruler.height + j * outputTileHeight),
            ),
          );
        }
      }

      game.camera.viewfinder.anchor = Anchor.topLeft;
      game.camera.viewfinder.position = Vector2(0, 0);
    }
  }
}

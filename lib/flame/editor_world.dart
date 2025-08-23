import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame/text.dart';
import 'package:tileseteditor/domain/tile_coord.dart';
import 'package:tileseteditor/domain/tile_info.dart';
import 'package:tileseteditor/flame/editor_game.dart';
import 'package:tileseteditor/flame/example_component.dart';
import 'package:tileseteditor/flame/tile_component.dart';

class EditorWorld extends World with HasGameReference<EditorGame>, HasCollisionDetection {
  Image? image;

  static final Size ruler = Size(20, 20);

  EditorWorld({required this.image});

  TextPaint rulerPaint = TextPaint(style: TextStyle(fontSize: 15.0, color: BasicPalette.black.color));

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
        /*
        add(
          RectangleComponent(
            paint: getBorderPaint(BasicPalette.black.color, 2),
            position: Vector2(ruler.width + (column - 1) * tileWidth, 0),
            size: Vector2(tileWidth.toDouble(), ruler.height),
          ),
        );*/
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
        /*
        add(
          RectangleComponent(
            paint: getBorderPaint(BasicPalette.black.color, 2),
            position: Vector2(0, ruler.height + (row - 1) * tileHeight),
            size: Vector2(ruler.width, tileHeight.toDouble()),
          ),
        );
        */
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

      for (int i = 0; i < atlasMaxX; i++) {
        for (int j = 0; j < atlasMaxY; j++) {
          TileCoord coord = TileCoord(i + 1, j + 1);
          TileInfo info = game.tileSet.getTileInfo(coord);
          add(
            TileComponent(
              tileSetImage: image!,
              spriteWidth: tileWidth.toDouble(),
              spriteHeight: tileHeight.toDouble(),
              atlasX: i,
              atlasY: j,
              position: Vector2(ruler.width + i * tileWidth, ruler.height + j * tileHeight),
              info: info,
              selected: game.isSelected(info),
            ),
          );
        }
      }

      game.camera.viewfinder.anchor = Anchor.topLeft;
      game.camera.viewfinder.position = Vector2(0, 0);
    }
  }
}

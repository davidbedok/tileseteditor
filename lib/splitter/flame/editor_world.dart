import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/splitter/flame/editor_game.dart';
import 'package:tileseteditor/splitter/flame/tile_component.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class EditorWorld extends World with HasGameReference<EditorGame>, HasCollisionDetection {
  EditorWorld();

  TextPaint rulerPaint = TextPaint(style: TextStyle(fontSize: 15.0, color: EditorColor.ruler.color));

  @override
  Future<void> onLoad() async {
    TileSet tileSet = game.tileSet;
    int tileWidth = tileSet.tileSize.widthPx;
    int tileHeight = tileSet.tileSize.heightPx;

    int atlasMaxX = tileSet.image!.width ~/ tileWidth;
    int atlasMaxY = tileSet.image!.height ~/ tileHeight;

    initRuler(tileWidth, tileHeight, atlasMaxX, atlasMaxY);

    for (int i = 0; i < atlasMaxX; i++) {
      for (int j = 0; j < atlasMaxY; j++) {
        add(
          TileComponent(
            tileSet: tileSet, //
            atlasX: i,
            atlasY: j,
            position: Vector2(DrawUtils.ruler.width + i * tileWidth, DrawUtils.ruler.height + j * tileHeight),
          ),
        );
      }
    }

    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2(0, 0);
  }

  void initRuler(int tileWidth, int tileHeight, int atlasMaxX, int atlasMaxY) {
    for (int column = 1; column <= atlasMaxX; column++) {
      add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$column',
          position: Vector2(DrawUtils.ruler.width + (column - 1) * tileWidth + 12, 0),
          size: Vector2(tileWidth.toDouble(), DrawUtils.ruler.height),
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
          position: Vector2(0, DrawUtils.ruler.height + (row - 1) * tileHeight + 6),
          size: Vector2(DrawUtils.ruler.width, tileHeight.toDouble()),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }
  }
}

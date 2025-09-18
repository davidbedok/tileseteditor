import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:tileseteditor/domain/editor_color.dart';
import 'package:tileseteditor/domain/tileset/tileset.dart';
import 'package:tileseteditor/splitter/flame/splitter_game.dart';
import 'package:tileseteditor/splitter/flame/tile_component.dart';
import 'package:tileseteditor/utils/draw_utils.dart';

class SplitterWorld extends World with HasGameReference<SplitterGame>, HasCollisionDetection {
  SplitterWorld();

  TextPaint rulerPaint = TextPaint(style: TextStyle(fontSize: 15.0, color: EditorColor.ruler.color));

  @override
  Future<void> onLoad() async {
    TileSet tileSet = game.tileSet;
    int tileWidth = tileSet.tileSize.widthPx;
    int tileHeight = tileSet.tileSize.heightPx;

    int atlasMaxX = tileSet.image!.width ~/ tileWidth;
    int atlasMaxY = tileSet.image!.height ~/ tileHeight;

    addAll(DrawUtils.getRulerComponents(atlasMaxX, atlasMaxY, tileWidth, tileHeight, 0));

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
}

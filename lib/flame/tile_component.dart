import 'dart:ui';

import 'package:flame/components.dart';
import 'package:tileseteditor/flame/editor_game.dart';

class TileComponent extends SpriteComponent with HasGameReference<EditorGame> {
  double spriteWidth;
  double spriteHeight;
  Image tileSetImage;

  int atlasX;
  int atlasY;

  TileComponent({
    required this.tileSetImage,
    required this.spriteWidth,
    required this.spriteHeight,
    required this.atlasX,
    required this.atlasY,
    required super.position,
  });

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(tileSetImage, srcPosition: Vector2(atlasX * spriteWidth, atlasY * spriteHeight), srcSize: Vector2(spriteWidth, spriteHeight));
    size = Vector2(spriteWidth, spriteHeight);
    // debugMode = true;
  }
}

import 'package:flame/components.dart';
import 'package:tileseteditor/flame/editor_game.dart';

class ExampleComponent extends SpriteComponent with HasGameReference<EditorGame> {
  static const int closenessLimit = 1;

  static const int spriteAtlasX = 4;
  static const int spriteAtlasY = 1;

  static const double spriteWidth = 32.0;
  static const double spriteHeight = 32.0;

  ExampleComponent({required super.position});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    sprite = Sprite(
      game.images.fromCache('magecity.png'),
      srcPosition: Vector2(spriteAtlasX * spriteWidth, spriteAtlasY * spriteHeight),
      srcSize: Vector2(spriteWidth, spriteHeight),
    );

    size = Vector2(spriteWidth, spriteHeight);
    debugMode = true;
  }
}

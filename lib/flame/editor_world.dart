import 'dart:ui';

import 'package:flame/components.dart';
import 'package:tileseteditor/flame/editor_game.dart';
import 'package:tileseteditor/flame/example_component.dart';
import 'package:tileseteditor/flame/tile_component.dart';

class EditorWorld extends World with HasGameReference<EditorGame>, HasCollisionDetection {
  Image? image;

  EditorWorld({required this.image});

  @override
  Future<void> onLoad() async {
    if (image == null) {
      add(ExampleComponent(position: Vector2(0, 0)));
    } else {
      print('img: ${image.toString()}');
      int atlasMaxX = image!.width ~/ 32;
      int atlasMaxY = image!.height ~/ 32;

      for (int i = 0; i < atlasMaxX; i++) {
        for (int j = 0; j < atlasMaxY; j++) {
          add(TileComponent(tileSetImage: image!, spriteWidth: 32, spriteHeight: 32, atlasX: i, atlasY: j, position: Vector2(i * 32, j * 32)));
        }
      }

      game.camera.viewfinder.anchor = Anchor.topLeft;
      game.camera.viewfinder.position = Vector2(0, 0);
    }
  }
}

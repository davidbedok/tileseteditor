import 'package:flame/components.dart';
import 'package:tileseteditor/flame/editor_game.dart';
import 'package:tileseteditor/flame/example_component.dart';

class EditorWorld extends World with HasGameReference<EditorGame>, HasCollisionDetection {
  @override
  Future<void> onLoad() async {
    add(ExampleComponent(position: Vector2(10, 10)));
  }
}

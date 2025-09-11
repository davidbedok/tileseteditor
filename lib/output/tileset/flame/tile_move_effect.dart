import 'package:flame/effects.dart';
import 'package:tileseteditor/output/tileset/flame/tileset_output_editor_world.dart';

class TileMoveEffect extends MoveToEffect {
  TileMoveEffect(
    super.destination,
    super.controller, {
    super.onComplete,
    this.transitPriority = TileSetOutputEditorWorld.movePriority,
    this.additionalPriority = 0,
    this.keepPriority = false,
  });

  final int transitPriority;
  final int additionalPriority;
  final bool keepPriority;

  @override
  void onStart() {
    super.onStart();
    if (!keepPriority) {
      parent?.priority = transitPriority + additionalPriority;
    }
  }
}

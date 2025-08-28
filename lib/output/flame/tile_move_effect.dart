import 'package:flame/effects.dart';
import 'package:tileseteditor/output/flame/single_tile_component.dart';

class TileMoveEffect extends MoveToEffect {
  TileMoveEffect(
    super.destination,
    super.controller, {
    super.onComplete,
    this.transitPriority = SingleTileComponent.movePriority,
    this.additionalPriority = 0,
    this.keepPriority = false,
  });

  final int transitPriority;
  final int additionalPriority;
  final bool keepPriority;

  @override
  void onStart() {
    super.onStart(); // Flame connects MoveToEffect to EffectController.
    if (!keepPriority) {
      parent?.priority = transitPriority + additionalPriority;
    }
  }
}

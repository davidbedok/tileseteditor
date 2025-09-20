import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class NavigationButtonComponent extends RectangleComponent {
  String label;

  NavigationButtonComponent({
    required this.label,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.paint,
    super.paintLayers,
    super.key,
  });

  factory NavigationButtonComponent.fromRect(
    String label,
    Rect rect, {
    Vector2? scale,
    double? angle,
    Anchor anchor = Anchor.topLeft,
    int? priority,
    Paint? paint,
    List<Paint>? paintLayers,
    ComponentKey? key,
    List<Component>? children,
  }) {
    return NavigationButtonComponent(
      label: label,
      position: anchor == Anchor.topLeft
          ? rect.topLeft.toVector2()
          : Anchor.topLeft.toOtherAnchorPosition(rect.topLeft.toVector2(), anchor, rect.size.toVector2()),
      size: rect.size.toVector2(),
      scale: scale,
      angle: angle,
      anchor: anchor,
      priority: priority,
      paint: paint,
      paintLayers: paintLayers,
      key: key,
      children: children,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    drawInfo(canvas);
  }

  void drawInfo(Canvas canvas) {
    var textSpan = TextSpan(
      text: label,
      style: TextStyle(color: const Color.fromARGB(255, 12, 5, 115), fontWeight: FontWeight.bold, fontSize: 30),
    );
    final textPainter = TextPainter(text: textSpan, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);

    double textWidth = textPainter.size.width;
    double textHeight = textPainter.size.height;
    double shiftLeft = (size.x - textWidth) / 2;
    double shiftTop = (size.y - textHeight) / 2;
    textPainter.paint(canvas, Offset(shiftLeft, shiftTop - 3));
  }
}

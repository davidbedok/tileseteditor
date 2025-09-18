import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:tileseteditor/domain/editor_color.dart';

class DrawUtils {
  static final Size ruler = Size(30, 30);

  static Paint getBorderPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  static Paint getFillPaint(Color color, {int alpha = 255}) {
    return Paint()
      ..color = color.withAlpha(alpha)
      ..style = PaintingStyle.fill;
  }

  static Paint getLinePaint(Color color, double strokeWidth, {StrokeCap strokeCap = StrokeCap.round}) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = strokeCap
      ..strokeWidth = strokeWidth;
  }

  static Size getTextSize(String text, double fontSize) {
    var textSpan = TextSpan(
      text: text,
      style: TextStyle(fontSize: fontSize),
    );
    final textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static List<TextComponent> getRulerComponents(int gridWidth, int gridHeight, int tileWidth, int tileHeight, double shiftLeft) {
    List<TextComponent> result = [];
    double fontSize = tileWidth / 2;
    TextPaint rulerPaint = TextPaint(
      style: TextStyle(fontSize: fontSize, color: EditorColor.ruler.color),
    );
    for (int column = 1; column <= gridWidth; column++) {
      Size textSize = DrawUtils.getTextSize('$column', fontSize);
      double paddingX = (tileWidth - textSize.width) / 2;
      double paddingY = (DrawUtils.ruler.height - textSize.height) / 2;
      result.add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$column',
          position: Vector2(shiftLeft + DrawUtils.ruler.width + (column - 1) * tileWidth + paddingX, paddingY),
          size: Vector2(DrawUtils.ruler.width, DrawUtils.ruler.height),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }
    for (int row = 1; row <= gridHeight; row++) {
      Size textSize = DrawUtils.getTextSize('$row', fontSize);
      double paddingX = (DrawUtils.ruler.width - textSize.width) / 2;
      double paddingY = (tileHeight - textSize.height) / 2;
      result.add(
        TextComponent(
          textRenderer: rulerPaint,
          text: '$row',
          position: Vector2(shiftLeft + paddingX, DrawUtils.ruler.height + (row - 1) * tileHeight + paddingY),
          size: Vector2(DrawUtils.ruler.width, tileHeight.toDouble()),
          anchor: Anchor.topLeft,
          priority: 20,
        ),
      );
    }
    return result;
  }
}

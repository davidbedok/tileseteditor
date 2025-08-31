import 'dart:ui';

class DrawUtils {
  static Paint getBorderPaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
  }

  static Paint getFillPaint(Color color, int alpha) {
    return Paint()
      ..color = color.withAlpha(alpha)
      ..style = PaintingStyle.fill;
  }
}

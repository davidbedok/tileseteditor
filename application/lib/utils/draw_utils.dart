import 'dart:ui';

class DrawUtils {
  static final Size ruler = Size(20, 20);

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

  static Paint getLinePaint(Color color, double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;
  }
}

import 'package:drawing_app/feature/drawing_canvas/models/stroke_spec.dart';
import 'package:flutter/material.dart';

class BrushPreviewPainter extends CustomPainter {
  final BrushStyleType type;
  final Color color;

  BrushPreviewPainter(this.type, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height / 2)
      ..quadraticBezierTo(
          size.width / 2, 0, size.width, size.height / 2);

    switch (type) {
      case BrushStyleType.normal:
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = 3
            ..style = PaintingStyle.stroke,
        );
        break;

      case BrushStyleType.soft:
        canvas.drawPath(
          path,
          Paint()
            ..color = color.withValues(alpha: 0.4)
            ..strokeWidth = 6
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
            ..style = PaintingStyle.stroke,
        );
        break;

      case BrushStyleType.neon:
        final glow = Paint()
          ..color = color.withValues(alpha: 0.5)
          ..strokeWidth = 8
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

        canvas.drawPath(path, glow);

        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = 3,
        );
        break;

      case BrushStyleType.dashed:
        final paint = Paint()
          ..color = color
          ..strokeWidth = 3;

        for (double i = 0; i < size.width; i += 8) {
          canvas.drawLine(
            Offset(i, size.height / 2),
            Offset(i + 6, size.height / 2),
            paint,
          );
        }
        break;

      case BrushStyleType.oil:
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = 8
            ..strokeCap = StrokeCap.round,
        );
        break;

      case BrushStyleType.spray:
        final paint = Paint()..color = color;
        for (int i = 0; i < 30; i++) {
          final dx = (i * 3) % size.width;
          final dy = size.height / 2 + (i % 5 - 2) * 2;
          canvas.drawCircle(Offset(dx, dy), 1.4, paint);
        }
        break;

      case BrushStyleType.marker:
        canvas.drawPath(
          path,
          Paint()
            ..color = color.withValues(alpha: 0.7)
            ..strokeWidth = 10,
        );
        break;

      case BrushStyleType.calligraphy:
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..strokeWidth = 6
            ..strokeCap = StrokeCap.square,
        );
        break;

      case BrushStyleType.gradient:
        final paint = Paint()
          ..shader = LinearGradient(
            colors: [Colors.purple.shade800, Colors.purple.shade100],
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
          ..strokeWidth = 4
          ..style = PaintingStyle.stroke;

        canvas.drawPath(path, paint);
        break;

      case BrushStyleType.pattern:
        final paint = Paint()..color = color;
        for (double i = 0; i < size.width; i += 6) {
          canvas.drawCircle(
              Offset(i, size.height / 2), 1.5, paint);
        }
        break;

      case BrushStyleType.watercolor:
        canvas.drawPath(
          path,
          Paint()
            ..color = color.withValues(alpha: 0.5)
            ..strokeWidth = 12
            ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 8),
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
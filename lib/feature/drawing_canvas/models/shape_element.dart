import 'dart:math' as math;

import 'package:drawing_app/feature/drawing_canvas/models/draw_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_spec.dart';
import 'package:flutter/material.dart';

class ShapeElement extends DrawElement {
  final Offset start;
  final Offset end;
  final ShapeSpec spec;

  const ShapeElement({
    required this.start,
    required this.end,
    required this.spec,
  });

  @override
  void paint(Canvas canvas) {
    final paint = spec.paint.toPaint(spec.strokeWidth)
      ..style = spec.filled ? PaintingStyle.fill : PaintingStyle.stroke;

    final rect = Rect.fromPoints(start, end);

    switch (spec.type) {
      case ShapeType.rectangle:
        canvas.drawRect(rect, paint);
        break;
      case ShapeType.square:
        final s = math.min(rect.width.abs(), rect.height.abs());
        final square = Rect.fromLTWH(rect.left, rect.top, s, s);
        canvas.drawRect(square, paint);
        break;
      case ShapeType.circle:
        final r = math.min(rect.width.abs(), rect.height.abs()) / 2;
        final c = rect.center;
        canvas.drawCircle(c, r, paint);
        break;
      case ShapeType.oval:
        canvas.drawOval(rect, paint);
        break;
      case ShapeType.line:
        paint.style = PaintingStyle.stroke;
        canvas.drawLine(start, end, paint);
        break;
      case ShapeType.arrow:
        paint.style = PaintingStyle.stroke;
        _paintArrow(canvas, paint, start, end);
        break;
      case ShapeType.triangle:
        final path = Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.left, rect.bottom)
          ..lineTo(rect.right, rect.bottom)
          ..close();
        canvas.drawPath(path, paint);
        break;
      case ShapeType.polygon:
        canvas.drawPath(_createPolygon(rect, 6), paint);
        break;
      case ShapeType.star:
        canvas.drawPath(_createStar(rect, 5), paint);
        break;
      case ShapeType.curve:
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(rect.center.dx, rect.top, end.dx, end.dy);
        canvas.drawPath(path, paint);
        break;
      case ShapeType.roundedRectangle:
        final rrect = RRect.fromRectAndRadius(rect, Radius.circular(20));
        canvas.drawRRect(rrect, paint);
        break;
    }
  }

  Path _createPolygon(Rect rect, int sides) {
    final path = Path();
    final center = rect.center;
    final radius = math.min(rect.width, rect.height) / 2;

    for (int i = 0; i < sides; i++) {
      final angle = (2 * math.pi * i) / sides - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  Path _createStar(Rect rect, int points) {
    final path = Path();
    final center = rect.center;
    final outerRadius = math.min(rect.width, rect.height) / 2;
    final innerRadius = outerRadius / 2.5;

    for (int i = 0; i < points * 2; i++) {
      final isOuter = i % 2 == 0;
      final radius = isOuter ? outerRadius : innerRadius;
      final angle = (math.pi * i) / points - math.pi / 2;

      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();
    return path;
  }

  void _paintArrow(Canvas canvas, Paint paint, Offset a, Offset b) {
    canvas.drawLine(a, b, paint);
    final dir = (b - a);
    if (dir.distance < 6) return;

    final angle = math.atan2(dir.dy, dir.dx);
    final headLen = math.max(10.0, spec.strokeWidth * 2.2);
    final headAngle = 0.55;

    final p1 =
        b -
        Offset(
          math.cos(angle - headAngle) * headLen,
          math.sin(angle - headAngle) * headLen,
        );
    final p2 =
        b -
        Offset(
          math.cos(angle + headAngle) * headLen,
          math.sin(angle + headAngle) * headLen,
        );
    canvas.drawLine(b, p1, paint);
    canvas.drawLine(b, p2, paint);
  }
}

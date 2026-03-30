import 'package:drawing_app/feature/drawing_canvas/models/shape_spec.dart';
import 'package:flutter/material.dart';

class ShapeIconPainter extends CustomPainter {
  final ShapeType type;
  final Color color;

  ShapeIconPainter(this.type, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;

    switch (type) {
      case ShapeType.rectangle:
        canvas.drawRect(rect, paint);
        break;

      case ShapeType.square:
        final s = size.shortestSide;
        canvas.drawRect(Rect.fromLTWH(0, 0, s, s), paint);
        break;

      case ShapeType.circle:
        canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
        break;

      case ShapeType.oval:
        canvas.drawOval(rect, paint);
        break;

      case ShapeType.line:
        canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
        break;

      case ShapeType.arrow:
        canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
        canvas.drawLine(
          Offset(size.width * 0.7, 0),
          Offset(size.width, 0),
          paint,
        );
        canvas.drawLine(
          Offset(size.width, size.height * 0.3),
          Offset(size.width, 0),
          paint,
        );
        break;

      case ShapeType.triangle:
        final path = Path()
          ..moveTo(size.width / 2, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();
        canvas.drawPath(path, paint);
        break;

      case ShapeType.polygon:
        final path = Path();
        path.moveTo(size.width / 2, 0);
        path.lineTo(size.width, size.height / 3);
        path.lineTo(size.width * 0.75, size.height);
        path.lineTo(size.width * 0.25, size.height);
        path.lineTo(0, size.height / 3);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case ShapeType.star:
        final path = Path();
        path.moveTo(size.width / 2, 0);
        path.lineTo(size.width * 0.6, size.height * 0.4);
        path.lineTo(size.width, size.height * 0.4);
        path.lineTo(size.width * 0.7, size.height * 0.65);
        path.lineTo(size.width * 0.8, size.height);
        path.lineTo(size.width / 2, size.height * 0.8);
        path.lineTo(size.width * 0.2, size.height);
        path.lineTo(size.width * 0.3, size.height * 0.65);
        path.lineTo(0, size.height * 0.4);
        path.lineTo(size.width * 0.4, size.height * 0.4);
        path.close();
        canvas.drawPath(path, paint);
        break;

      case ShapeType.curve:
        final path = Path()
          ..moveTo(0, size.height)
          ..quadraticBezierTo(size.width / 2, 0, size.width, size.height);
        canvas.drawPath(path, paint);
        break;

      case ShapeType.roundedRectangle:
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(8)),
          paint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
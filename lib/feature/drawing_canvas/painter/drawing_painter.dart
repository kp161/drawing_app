import 'package:drawing_app/feature/drawing_canvas/controllers/drawing_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/models/draw_element.dart';
import 'package:flutter/material.dart';

class DrawingPainter extends CustomPainter {
  final DrawingController controller;
  final DrawElement? preview;
  final Color backgroundColor;

  DrawingPainter({
    required this.controller,
    required this.preview,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());

    if (backgroundColor != Colors.transparent) {
      final bg = Paint()..color = backgroundColor;
      canvas.drawRect(Offset.zero & size, bg);
    }

    controller.drawCommittedLayer(canvas, size);
    preview?.paint(canvas);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    return true;
  }
}
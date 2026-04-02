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
    // Needed so BlendMode.clear erases correctly.
    canvas.saveLayer(Offset.zero & size, Paint());

    if (backgroundColor != Colors.transparent) {
      final bg = Paint()..color = backgroundColor;
      canvas.drawRect(Offset.zero & size, bg);
    }

    // Layer 1: cached committed strokes/shapes.
    controller.drawCommittedLayer(canvas, size);
    // Layer 2: currently active live element.
    preview?.paint(canvas);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant DrawingPainter oldDelegate) {
    // We repaint whenever this painter is rebuilt (AnimatedBuilder listens to the
    // controller). Undo/redo changes the controller's internal element list
    // without changing `preview`, so we must not rely only on references.
    return true;
  }
}
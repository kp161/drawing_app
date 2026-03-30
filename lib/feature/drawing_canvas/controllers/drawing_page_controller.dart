import 'dart:math' as math;
import 'package:drawing_app/feature/drawing_canvas/controllers/color_selection_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/controllers/drawing_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/models/paint_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/drawing_tools.dart';
import 'package:flutter/material.dart';

class DrawingPageController {
  final ColorSelectionController colorController;
  final DrawingController drawingController;

  DrawingToolType selectedTool = DrawingToolType.brush;

  BrushStyleType brushStyle = BrushStyleType.normal;
  double strokeWidth = 8;
  double opacity = 1.0;

  ShapeType shapeType = ShapeType.rectangle;
  bool shapeFilled = false;
  double shapeStrokeWidth = 6;

  DrawingPageController(this.colorController, this.drawingController);

  void onPanStart(Offset p, Size canvasSize) {
    final paintSpec = _currentPaintSpec(canvasSize);

    switch (selectedTool) {
      case DrawingToolType.brush:
        drawingController.startStroke(
          StrokeSpec(
            paint: paintSpec,
            width: strokeWidth,
            isEraser: false,
            brushStyle: brushStyle,
            smooth: false,
          ),
          p,
        );
        break;

      case DrawingToolType.pen:
        drawingController.startStroke(
          StrokeSpec(
            paint: paintSpec,
            width: math.max(1.5, strokeWidth * 0.45),
            isEraser: false,
            brushStyle: BrushStyleType.normal,
            smooth: true,
          ),
          p,
        );
        break;

      case DrawingToolType.eraser:
        drawingController.startStroke(
          StrokeSpec(
            paint: const PaintSpec.solid(Colors.transparent),
            width: math.max(10, strokeWidth * 1.25),
            isEraser: true,
            brushStyle: BrushStyleType.normal,
            smooth: false,
          ),
          p,
        );
        break;

      case DrawingToolType.shape:
        drawingController.startShape(
          ShapeSpec(
            type: shapeType,
            strokeWidth: shapeStrokeWidth,
            filled: shapeFilled,
            paint: paintSpec,
          ),
          p,
        );
        break;
    }
  }

  void onPanUpdate(Offset p) {
    drawingController.update(p);
  }

  void onPanEnd() {
    drawingController.end();
  }

  PaintSpec _currentPaintSpec(Size canvasSize) {
    final v = colorController.value;
    final opacityValue = opacity.clamp(0.0, 1.0);

    return PaintSpec.solid(
      v.solidColor.withValues(alpha: opacityValue),
    );
  }
}
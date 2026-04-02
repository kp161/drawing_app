import 'package:drawing_app/feature/drawing_canvas/controllers/color_selection_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/controllers/drawing_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/painter/drawing_painter.dart';
import 'package:flutter/material.dart';

class CanvasSection extends StatelessWidget {
  final DrawingController drawingController;
  final ColorSelectionController colorController;
  final ImageProvider? backgroundImage;

  final Function(Offset, Size) onPanStart;
  final Function(Offset, Size) onPanUpdate;
  final VoidCallback onPanEnd;

  const CanvasSection({
    super.key,
    required this.drawingController,
    required this.colorController,
    this.backgroundImage,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
          child: Container(
            color: Colors.black12.withValues(alpha: 0.05),
            child: Stack(
              children: [
                Positioned.fill(
                  child: backgroundImage != null
                     ? Image(image: backgroundImage!,
                     fit: BoxFit.cover,) : Container(
                      color: Colors.white,
                     ),
                ),

                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (d) => onPanStart(d.localPosition, size),
                    onPanUpdate: (d) => onPanUpdate(d.localPosition, size),
                    onPanEnd: (_) => onPanEnd(),
                    child: RepaintBoundary(
                      child: AnimatedBuilder(
                        animation: drawingController,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: DrawingPainter(
                              controller: drawingController,
                              preview: drawingController.preview,
                              backgroundColor: Colors.transparent,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

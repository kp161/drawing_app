import 'package:drawing_app/feature/drawing_canvas/models/paint_spec.dart';

enum BrushStyleType {
  normal,
  soft,
  neon,
  dashed,
  oil,
  spray,
  marker,
  calligraphy,
  gradient,
  pattern,
  watercolor,
}

class StrokeSpec {
  final PaintSpec paint;
  final double width;
  final bool isEraser;
  final BrushStyleType brushStyle;
  final bool smooth;

  const StrokeSpec({
    required this.paint,
    required this.width,
    required this.isEraser,
    required this.brushStyle,
    required this.smooth,
  });
}

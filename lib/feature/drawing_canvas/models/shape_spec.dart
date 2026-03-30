import 'package:drawing_app/feature/drawing_canvas/models/paint_spec.dart';

enum ShapeType {
  rectangle,
  roundedRectangle,
  square,
  circle,
  oval,
  triangle,
  polygon,
  star,
  line,
  arrow,
  curve,
}

class ShapeSpec {
  final ShapeType type;
  final double strokeWidth;
  final bool filled;
  final PaintSpec paint;

  const ShapeSpec({
    required this.type,
    required this.strokeWidth,
    required this.filled,
    required this.paint,
  });
}

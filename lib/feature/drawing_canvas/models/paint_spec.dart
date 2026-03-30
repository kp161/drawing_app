import 'package:flutter/material.dart';

abstract class PaintSpec {
  const PaintSpec();
  Paint toPaint(double strokeWidth);

  const factory PaintSpec.solid(Color color) = SolidPaintSpec;
}

class SolidPaintSpec extends PaintSpec {
  final Color color;
  const SolidPaintSpec(this.color);

  @override
  Paint toPaint(double strokeWidth) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
  }
}

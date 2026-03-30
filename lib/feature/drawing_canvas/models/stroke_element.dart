import 'dart:math' as math;
import 'dart:ui';

import 'package:drawing_app/feature/drawing_canvas/models/draw_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_spec.dart';
import 'package:flutter/material.dart';

class StrokeElement extends DrawElement {
  final List<Offset> points;
  final StrokeSpec spec;

  const StrokeElement({required this.points, required this.spec});

  @override
  void paint(Canvas canvas) {
    final paint = spec.isEraser
        ? _eraserPaint(spec.width)
        : spec.paint.toPaint(spec.width);

    // ================= BASE EFFECTS =================

    switch (spec.brushStyle) {
      case BrushStyleType.soft:
        if (!spec.isEraser) {
          paint.maskFilter = MaskFilter.blur(
            BlurStyle.normal,
            spec.width * 0.35,
          );
        }
        break;

      case BrushStyleType.neon:
        if (!spec.isEraser) {
          paint
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, spec.width * 0.6)
            ..color = paint.color.withValues(
              alpha: (paint.color.a * 0.9).clamp(0.0, 1.0),
            );
        }
        break;

      case BrushStyleType.marker:
        if (!spec.isEraser) {
          paint
            ..strokeCap = StrokeCap.square
            ..strokeWidth = spec.width * 1.2
            ..color = paint.color.withValues(alpha: 0.85);
        }
        break;

      case BrushStyleType.calligraphy:
        if (!spec.isEraser) {
          paint
            ..strokeCap = StrokeCap.square
            ..strokeWidth = spec.width * 1.4;
        }
        break;

      default:
        break;
    }

    // ================= POINT CASE =================

    if (points.length < 2) {
      canvas.drawPoints(
        PointMode.points,
        points,
        paint..strokeWidth = spec.width,
      );
      return;
    }

    // ================= SPECIAL BRUSHES =================

    if (spec.brushStyle == BrushStyleType.spray && !spec.isEraser) {
      _paintSpray(canvas, paint);
      return;
    }

    final path = spec.smooth ? _smoothPath(points) : _polylinePath(points);

    if (spec.brushStyle == BrushStyleType.dashed && !spec.isEraser) {
      _paintDashedPath(
        canvas,
        path,
        paint,
        dash: spec.width * 1.2,
        gap: spec.width * 0.9,
      );
      return;
    }

    if (spec.brushStyle == BrushStyleType.oil && !spec.isEraser) {
      _paintOil(canvas, path, paint);
      return;
    }

    if (spec.brushStyle == BrushStyleType.gradient && !spec.isEraser) {
      _paintGradient(canvas, path, paint);
      return;
    }

    if (spec.brushStyle == BrushStyleType.pattern && !spec.isEraser) {
      _paintPattern(canvas, path, paint);
      return;
    }

    if (spec.brushStyle == BrushStyleType.watercolor && !spec.isEraser) {
      _paintWatercolor(canvas, path, paint);
      return;
    }

    // ================= DEFAULT =================

    canvas.drawPath(path, paint);
  }

  void _paintOil(Canvas canvas, Path path, Paint paint) {
    final oilPaint = paint
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = spec.width * 1.1;

    canvas.drawPath(path, oilPaint);

    final highlight = Paint()
      ..color = paint.color.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(1.0, spec.width * 0.35);

    canvas.drawPath(path.shift(const Offset(1, -1)), highlight);
  }

  void _paintGradient(Canvas canvas, Path path, Paint basePaint) {
    final bounds = path.getBounds();

    final gradientPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = basePaint.strokeWidth
      ..shader = LinearGradient(
        colors: [basePaint.color, basePaint.color.withValues(alpha: 0.2)],
      ).createShader(bounds);

    canvas.drawPath(path, gradientPaint);
  }

  void _paintPattern(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final pos = metric.getTangentForOffset(distance)?.position;
        if (pos != null) {
          canvas.drawCircle(pos, spec.width * 0.3, paint);
        }
        distance += spec.width;
      }
    }
  }

  void _paintWatercolor(Canvas canvas, Path path, Paint basePaint) {
    final rnd = math.Random(points.hashCode);

    final watercolorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = spec.width
      ..color = basePaint.color.withValues(alpha: 0.25);

    // draw multiple transparent strokes
    for (int i = 0; i < 3; i++) {
      final dx = rnd.nextDouble() * 2 - 1;
      final dy = rnd.nextDouble() * 2 - 1;

      canvas.drawPath(path.shift(Offset(dx, dy)), watercolorPaint);
    }
  }

  Path _polylinePath(List<Offset> pts) {
    final p = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      p.lineTo(pts[i].dx, pts[i].dy);
    }
    return p;
  }

  Path _smoothPath(List<Offset> pts) {
    final p = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length - 1; i++) {
      final current = pts[i];
      final next = pts[i + 1];
      final mid = Offset(
        (current.dx + next.dx) / 2,
        (current.dy + next.dy) / 2,
      );
      p.quadraticBezierTo(current.dx, current.dy, mid.dx, mid.dy);
    }
    p.lineTo(pts.last.dx, pts.last.dy);
    return p;
  }

  void _paintDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    required double dash,
    required double gap,
  }) {
    for (final m in path.computeMetrics()) {
      double distance = 0;
      while (distance < m.length) {
        final len = math.min(dash, m.length - distance);
        final seg = m.extractPath(distance, distance + len);
        canvas.drawPath(seg, paint);
        distance += dash + gap;
      }
    }
  }

  void _paintSpray(Canvas canvas, Paint basePaint) {
    final rnd = math.Random(points.hashCode);
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = basePaint.color.withValues(
        alpha: (basePaint.color.a * 0.35).clamp(0.0, 1.0),
      );

    final radius = math.max(6.0, spec.width * 1.3);
    final dotsPerPoint = (spec.width * 2.2).clamp(10.0, 60.0).toInt();

    for (final p in points) {
      for (int i = 0; i < dotsPerPoint; i++) {
        final a = rnd.nextDouble() * math.pi * 2;
        final r = rnd.nextDouble() * radius;
        final off = Offset(math.cos(a) * r, math.sin(a) * r);
        canvas.drawCircle(p + off, rnd.nextDouble() * 1.2 + 0.6, dotPaint);
      }
    }
  }

  Paint _eraserPaint(double width) {
    return Paint()
      ..blendMode = BlendMode.clear
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
  }
}

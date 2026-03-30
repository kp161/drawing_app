import 'package:flutter/material.dart';

enum PaintMode { solid, gradient }

@immutable
class SelectedPaint {
  final PaintMode mode;
  final Color solidColor;
  final double opacity; // 0..1

  const SelectedPaint({
    required this.mode,
    required this.solidColor,
    required this.opacity,
  });
  factory SelectedPaint.initial() {
    return const SelectedPaint(
      mode: PaintMode.solid,
      solidColor: Colors.deepPurple,
      opacity: 1.0,
    );
  }

  SelectedPaint copyWith({
    PaintMode? mode,
    Color? solidColor,
    double? opacity,
  }) {
    return SelectedPaint(
      mode: mode ?? this.mode,
      solidColor: solidColor ?? this.solidColor,
      opacity: opacity ?? this.opacity,
    );
  }

  bool get isSolid => mode == PaintMode.solid;

  Color get solidWithOpacity => solidColor.withValues(alpha: opacity);
}

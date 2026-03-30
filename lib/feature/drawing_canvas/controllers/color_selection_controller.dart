import 'package:drawing_app/feature/drawing_canvas/models/selected_paint.dart';
import 'package:flutter/material.dart';

class ColorSelectionController extends ChangeNotifier {
  SelectedPaint _value;

  ColorSelectionController({SelectedPaint? initial})
    : _value = initial ?? SelectedPaint.initial();

  SelectedPaint get value => _value;

  void selectSolid(Color color) {
    _setValue(_value.copyWith(mode: PaintMode.solid, solidColor: color));
  }

  void setOpacity(double opacity) {
    final next = opacity.clamp(0.0, 1.0).toDouble();
    _setValue(_value.copyWith(opacity: next));
  }

  void _setValue(SelectedPaint next) {
    if (identical(next, _value)) return;
    if (next.mode == _value.mode &&
        next.solidColor.toARGB32() == _value.solidColor.toARGB32() &&
        next.opacity == _value.opacity) {
      return;
    }
    _value = next;
    notifyListeners();
  }
}

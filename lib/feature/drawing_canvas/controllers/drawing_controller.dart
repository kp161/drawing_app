import 'package:drawing_app/feature/drawing_canvas/models/draw_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_spec.dart';
import 'package:flutter/material.dart';

class DrawingController extends ChangeNotifier {
  final List<DrawElement> _elements = <DrawElement>[];
  final List<DrawElement> _redoElements = <DrawElement>[];

  List<DrawElement> get elements => List.unmodifiable(_elements);
  bool get canUndo => _elements.isNotEmpty;
  bool get canRedo => _redoElements.isNotEmpty;

  DrawElement? preview;

  StrokeSpec? _activeStrokeSpec;
  ShapeSpec? _activeShapeSpec;
  List<Offset>? _activePoints;
  Offset? _shapeStart;

  void startStroke(StrokeSpec spec, Offset start) {
    _activeStrokeSpec = spec;
    _activeShapeSpec = null;
    _shapeStart = null;
    _activePoints = <Offset>[start];
    preview = StrokeElement(
      points: List.unmodifiable(_activePoints!),
      spec: spec,
    );
    notifyListeners();
  }

  void startShape(ShapeSpec spec, Offset start) {
    _activeShapeSpec = spec;
    _activeStrokeSpec = null;
    _activePoints = null;
    _shapeStart = start;
    preview = ShapeElement(start: start, end: start, spec: spec);
    notifyListeners();
  }

  void update(Offset p) {
    if (_activeStrokeSpec != null && _activePoints != null) {
      _activePoints!.add(p);
      preview = StrokeElement(
        points: List.unmodifiable(_activePoints!),
        spec: _activeStrokeSpec!,
      );
      notifyListeners();
      return;
    }

    if (_activeShapeSpec != null && _shapeStart != null) {
      preview = ShapeElement(
        start: _shapeStart!,
        end: p,
        spec: _activeShapeSpec!,
      );
      notifyListeners();
    }
  }

  void end() {
    if (preview != null) {
      _elements.add(preview!);
      // Once the user makes a new stroke, redo history becomes invalid.
      _redoElements.clear();
    }
    preview = null;
    _activeStrokeSpec = null;
    _activeShapeSpec = null;
    _activePoints = null;
    _shapeStart = null;
    notifyListeners();
  }

  void undo() {
    if (!canUndo) return;
    final last = _elements.removeLast();
    _redoElements.add(last);
    preview = null;
    notifyListeners();
  }

  void redo() {
    if (!canRedo) return;
    final last = _redoElements.removeLast();
    _elements.add(last);
    preview = null;
    notifyListeners();
  }
}

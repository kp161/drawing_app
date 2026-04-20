import 'package:drawing_app/feature/drawing_canvas/models/draw_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_element.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_spec.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DrawingController extends ChangeNotifier {
  final List<DrawElement> _elements = <DrawElement>[];
  final List<DrawElement> _redoElements = <DrawElement>[];
  ui.Picture? _cachedCommittedPicture;
  Size? _cachedPictureSize;
  bool _isCacheDirty = true;

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
      _markCacheDirty();
    }
    preview = null;
    _activeStrokeSpec = null;
    _activeShapeSpec = null;
    _activePoints = null;
    _shapeStart = null;
    notifyListeners();
  }

  void undo() {
    if (_elements.isEmpty) return;

    _redoElements.add(_elements.removeLast());

    preview = null;
    _markCacheDirty();
    notifyListeners();
  }

  void redo() {
    if (_redoElements.isEmpty) return;

    _elements.add(_redoElements.removeLast());

    preview = null;
    _markCacheDirty();
    notifyListeners();
  }

  void drawCommittedLayer(Canvas canvas, Size size) {
    _rebuildCacheIfNeeded(size);
    final picture = _cachedCommittedPicture;
    if (picture != null) {
      canvas.drawPicture(picture);
    }
  }

  void _markCacheDirty() {
    _isCacheDirty = true;
  }

  void _rebuildCacheIfNeeded(Size size) {
    if (!_isCacheDirty &&
        _cachedCommittedPicture != null &&
        _cachedPictureSize == size) {
      return;
    }

    _cachedCommittedPicture?.dispose();
    final recorder = ui.PictureRecorder();
    final cacheCanvas = Canvas(recorder);
    for (final e in _elements) {
      e.paint(cacheCanvas);
    }
    _cachedCommittedPicture = recorder.endRecording();
    _cachedPictureSize = size;
    _isCacheDirty = false;
  }

  @override
  void dispose() {
    _cachedCommittedPicture?.dispose();
    super.dispose();
  }
}

import 'package:drawing_app/feature/drawing_canvas/sections/labeled_slider.dart';
import 'package:drawing_app/feature/drawing_canvas/sections/shape_icon_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drawing_app/feature/drawing_canvas/models/shape_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/bottom_sheet_container.dart';

Future<void> showShapesBottomSheet({
  required BuildContext context,
  required ShapeType selectedShape,
  required double strokeWidth,
  required bool isFilled,
  required Function(ShapeType) onShapeChanged,
  required Function(double) onStrokeWidthChanged,
  required Function(bool) onFillChanged,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      ShapeType localShape = selectedShape;
      double localStrokeWidth = strokeWidth;
      bool localFilled = isFilled;

      return BottomSheetContainer(
        title: 'Shapes',
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shape options',
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: ShapeType.values.map((s) {
                    final selected = localShape == s;
                    return GestureDetector(
                      onTap: () {
                        localShape = s;
                        onShapeChanged(s);
                        setSheetState(() {});
                      },
                      child: AnimatedContainer(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        duration: Duration(milliseconds: 200),
                        width: 75,
                        height: 80,
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.deepPurple.shade50
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? Colors.deepPurple
                                : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (selected)
                              BoxShadow(
                                color: Colors.deepPurple.withValues(alpha: 0.2),
                                blurRadius: 8,
                              ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _shapeIcon(s, selected),
                            const SizedBox(height: 4),
                            Text(
                              _shapeLabel(s),
                              style: GoogleFonts.fredoka(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                LabeledSlider(
                  label: 'Stroke width',
                  value: localStrokeWidth,
                  min: 1,
                  max: 40,
                  onChanged: (v) {
                    localStrokeWidth = v;
                    onStrokeWidthChanged(v);
                    setSheetState(() {});
                  },
                ),
                const SizedBox(height: 8),
                SwitchListTile.adaptive(
                  value: localFilled,
                  onChanged: (v) {
                    localFilled = v;
                    onFillChanged(v);
                    setSheetState(() {});
                  },
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Filled',
                    style: GoogleFonts.fredoka(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

String _shapeLabel(ShapeType s) {
  switch (s) {
    case ShapeType.rectangle:
      return 'Rectangle';
    case ShapeType.square:
      return 'Square';
    case ShapeType.circle:
      return 'Circle';
    case ShapeType.oval:
      return 'Oval';
    case ShapeType.line:
      return 'Line';
    case ShapeType.arrow:
      return 'Arrow';
    case ShapeType.triangle:
      return 'Triangle';
    case ShapeType.polygon:
      return 'Polygon';
    case ShapeType.star:
      return 'Star';
    case ShapeType.curve:
      return 'Curve';
    case ShapeType.roundedRectangle:
      return 'Rounded Rectangle';
  }
}

Widget _shapeIcon(ShapeType type, bool selected) {
  final color = selected ? Colors.deepPurple : Colors.black87;

  return SizedBox(
    width: 30,
    height: 30,
    child: CustomPaint(painter: ShapeIconPainter(type, color)),
  );
}

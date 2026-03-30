import 'package:drawing_app/feature/drawing_canvas/sections/brush_preview_painter.dart';
import 'package:drawing_app/feature/drawing_canvas/sections/labeled_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drawing_app/feature/drawing_canvas/models/stroke_spec.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/bottom_sheet_container.dart';

Future<void> showBrushBottomSheet({
  required BuildContext context,
  required BrushStyleType selectedStyle,
  required double strokeWidth,
  required double opacity,
  required Function(BrushStyleType) onStyleChanged,
  required Function(double) onStrokeWidthChanged,
  required Function(double) onOpacityChanged,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      BrushStyleType localStyle = selectedStyle;
      double localStrokeWidth = strokeWidth;
      double localOpacity = opacity;

      return BottomSheetContainer(
        title: 'Brush Settings',
        child: StatefulBuilder(
          builder: (context, setSheetState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Brush styles',
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
                  children: BrushStyleType.values.map((s) {
                    final selected = localStyle == s;
                    return GestureDetector(
                      onTap: () {
                        localStyle = s;
                        onStyleChanged(s);
                        setSheetState(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 80,
                        height: 80,
                        padding: const EdgeInsets.all(8),
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
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _brushPreview(s, selected),
                            const SizedBox(height: 6),
                            Text(
                              _brushLabel(s),
                              style: const TextStyle(fontSize: 10),
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
                const SizedBox(height: 10),
                LabeledSlider(
                  label: 'Opacity',
                  value: localOpacity,
                  min: 0.05,
                  max: 1,
                  onChanged: (v) {
                    localOpacity = v;
                    onOpacityChanged(v);
                    setSheetState(() {});
                  },
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Widget _brushPreview(BrushStyleType type, bool selected) {
  return SizedBox(
    width: 40,
    height: 30,
    child: CustomPaint(
      painter: BrushPreviewPainter(
        type,
        selected ? Colors.deepPurple : Colors.black,
      ),
    ),
  );
}

String _brushLabel(BrushStyleType b) {
  switch (b) {
    case BrushStyleType.normal:
      return 'Normal';
    case BrushStyleType.soft:
      return 'Soft';
    case BrushStyleType.neon:
      return 'Glow';
    case BrushStyleType.dashed:
      return 'Dash';
    case BrushStyleType.oil:
      return 'Oil';
    case BrushStyleType.spray:
      return 'Spray';
    case BrushStyleType.marker:
      return 'Marker';
    case BrushStyleType.calligraphy:
      return 'Calligraphy';
    case BrushStyleType.gradient:
      return 'Gradient';
    case BrushStyleType.pattern:
      return 'Dots';
    case BrushStyleType.watercolor:
      return 'Water';
  }
}

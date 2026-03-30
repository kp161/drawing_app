import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final double min;
  final ValueChanged<double> onChanged;

  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    required this.min,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: const Color(0xFF0F172A),
              ),
            ),
            Text(
              value.toStringAsFixed(label == 'Opacity' ? 2 : 0),
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          onChanged: onChanged,
          activeColor: Colors.deepPurple,
        ),
      ],
    );
  }
}

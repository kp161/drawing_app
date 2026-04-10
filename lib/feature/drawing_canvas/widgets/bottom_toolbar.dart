import 'package:drawing_app/feature/drawing_canvas/controllers/color_selection_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/color_picker.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/drawing_tools.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomToolbar extends StatelessWidget {
  final double bottomInset;
  final DrawingToolType selectedTool;
  final Function(DrawingToolType) onToolSelected;
  final double strokeWidth;
  final ValueChanged<double> onStrokeWidthChanged;
  final ColorSelectionController colorController;

  const BottomToolbar({
    super.key,
    required this.bottomInset,
    required this.selectedTool,
    required this.onToolSelected,
    required this.strokeWidth,
    required this.onStrokeWidthChanged,
    required this.colorController,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(

      width: isLandscape ? 120 : double.infinity,
      padding: EdgeInsets.fromLTRB(
        15,
        10,
        15,
        isLandscape ? 10 : 10 + bottomInset,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: isLandscape
            ? const BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              )
            : const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
      ),
      child: isLandscape
          ? _buildVerticalLayout() 
          : _buildHorizontalLayout(),
    );
  }

  // --- PORTRAIT MODE (Bottom) ---
  Widget _buildHorizontalLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min, 
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DrawingTools(
          selectedTool: selectedTool,
          onToolSelected: onToolSelected,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Size",
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: const Color(0xFF1E293B),
              ),
            ),
            Text(
              "${strokeWidth.toStringAsFixed(0)}px",
              style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
          ),
          child: Slider(
            value: strokeWidth,
            min: 1,
            max: 40,
            onChanged: onStrokeWidthChanged,
            activeColor: Colors.deepPurple,
          ),
        ),
        const SizedBox(height: 5),
        ColorPickerRow(controller: colorController),
      ],
    );
  }

  // --- LANDSCAPE MODE (Side) ---
  Widget _buildVerticalLayout() {
    return SingleChildScrollView(
      child: Column(
        children: [
          DrawingTools(
            selectedTool: selectedTool,
            onToolSelected: onToolSelected,
          ),
          const Divider(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Size",
                style: GoogleFonts.fredoka(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 150,
                width: 30,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    value: strokeWidth,
                    min: 1,
                    max: 40,
                    onChanged: onStrokeWidthChanged,
                    activeColor: Colors.deepPurple,
                  ),
                ),
              ),
              Text(
                "${strokeWidth.toStringAsFixed(0)}px",
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),

          const Divider(height: 30),
          ColorPickerRow(controller: colorController),
        ],
      ),
    );
  }
}

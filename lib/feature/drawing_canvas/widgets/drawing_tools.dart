import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

enum DrawingToolType { brush, pen, eraser, shape }

class DrawingTools extends StatelessWidget {
  final DrawingToolType selectedTool;
  final ValueChanged<DrawingToolType> onToolSelected;

  const DrawingTools({
    super.key,
    required this.selectedTool,
    required this.onToolSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Wrap(
      spacing: isLandscape ? 8 : 12,
      runSpacing: 12,
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _toolButton(
          isLandscape,
          iconPath: 'assets/icons/brush.svg',
          label: "BRUSH",
          color: Color(0xFFD0DEF5),
          isSelected: selectedTool == DrawingToolType.brush,
          onTap: () => onToolSelected(DrawingToolType.brush),
        ),
        _toolButton(
          isLandscape,
          iconPath: 'assets/icons/pen.svg',
          label: "PEN",
          color: Color(0xFFFFF0D0),
          isSelected: selectedTool == DrawingToolType.pen,
          onTap: () => onToolSelected(DrawingToolType.pen),
        ),
        _toolButton(
          isLandscape,
          iconPath: 'assets/icons/eraser.svg',
          label: "ERASER",
          color: Color(0xFFFCE7F3),
          isSelected: selectedTool == DrawingToolType.eraser,
          onTap: () => onToolSelected(DrawingToolType.eraser),
        ),
        _toolButton(
          isLandscape,
          iconPath: 'assets/icons/shapes.svg',
          label: "SHAPES",
          color: Color(0xFFFFE6D8),
          isSelected: selectedTool == DrawingToolType.shape,
          onTap: () => onToolSelected(DrawingToolType.shape),
        ),
      ],
    );
  }

  Widget _toolButton(
    bool isLandscape, {
    required String iconPath,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            height: isLandscape ? 45 : 55,
            width: isLandscape ? 45 : 55,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.deepPurple : color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.deepPurple.withValues(alpha: 0.22),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: SvgPicture.asset(
              iconPath,
              colorFilter: isSelected
                  ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                  : null,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: GoogleFonts.fredoka(
              fontSize: isLandscape
                  ? 9
                  : 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.deepPurple : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:drawing_app/feature/drawing_canvas/controllers/color_selection_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/all_color_bottom_sheet.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/color_circle.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/color_picker_bottom_sheet.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/icon_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorPickerRow extends StatefulWidget {
  final ColorSelectionController controller;

  const ColorPickerRow({super.key, required this.controller});

  @override
  State<ColorPickerRow> createState() => _ColorPickerRowState();
}

class _ColorPickerRowState extends State<ColorPickerRow> {
  final List<Color> _quickColors = Colors.primaries
      .expand(
        (color) => [
          color.shade200,
          color.shade400,
          color.shade600,
          color.shade800,
        ],
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Column(
      crossAxisAlignment: isLandscape
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          "Choose color",
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 10),
        isLandscape ? _buildLandscapeLayout() : _buildPortraitLayout(),
      ],
    );
  }

  void _openColorPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ColorPickerBottomSheet(controller: widget.controller);
      },
    );
  }

  void _openAllColorsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AllColorBottomSheet(controller: widget.controller);
      },
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButtons(
          icon: Icons.add,
          ontap: _openColorPickerBottomSheet,
          isGradient: true,
        ),
        IconButtons(
          icon: Icons.keyboard_arrow_up,
          ontap: _openAllColorsBottomSheet,
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              final value = widget.controller.value;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickColors.length,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                itemBuilder: (context, index) {
                  final c = _quickColors[index];
                  final isSelected =
                      value.isSolid &&
                      value.solidColor.toARGB32() == c.toARGB32();
                  return GestureDetector(
                    onTap: () => widget.controller.selectSolid(c),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ColorCircle(color: c, selected: isSelected),
                    ),
                  );
                },
              );
            },
          ),
          Positioned(
            left: 0,
            child: IconButtons(
              icon: Icons.add,
              ontap: _openColorPickerBottomSheet,
              isGradient: true,
            ),
          ),
          Positioned(
            right: 0,
            child: IconButtons(
              icon: Icons.keyboard_arrow_up,
              ontap: _openAllColorsBottomSheet,
            ),
          ),
        ],
      ),
    );
  }
}

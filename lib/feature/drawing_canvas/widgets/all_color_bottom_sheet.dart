import 'package:drawing_app/feature/drawing_canvas/controllers/color_selection_controller.dart';
import 'package:drawing_app/feature/drawing_canvas/widgets/color_circle.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllColorBottomSheet extends StatelessWidget {
  final ColorSelectionController controller;

  const AllColorBottomSheet({super.key, required this.controller});

  static final List<Color> _colors = Colors.primaries
      .expand(
        (color) => [
          color.shade50,
          color.shade100,
          color.shade200,
          color.shade300,
          color.shade400,
          color.shade500,
          color.shade600,
          color.shade700,
          color.shade800,
          color.shade900,
        ],
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.50,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Text(
                'Custom Colors',
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 18),
              AnimatedBuilder(
                animation: controller,
                builder: (context, _) {
                  final value = controller.value;
                  final selectedIndex = value.isSolid
                      ? _colors.indexWhere(
                          (c) => c.toARGB32() == value.solidColor.toARGB32(),
                        )
                      : -1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 60,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1,
                        ),
                    itemCount: _colors.length,
                    itemBuilder: (context, index) {
                      final c = _colors[index];
                      return GestureDetector(
                        onTap: () => controller.selectSolid(c),
                        child: ColorCircle(
                          color: c,
                          selected: selectedIndex == index,
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

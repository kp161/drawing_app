import 'package:drawing_app/feature/category/widgets/build_lanscape_layout.dart';
import 'package:drawing_app/feature/category/widgets/build_portrait_layout.dart';
import 'package:drawing_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: CustomLogo(),
        title: Text(
          'Doodle Studio',
          style: GoogleFonts.splineSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF7F13EC),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: OrientationBuilder(
          builder: (context, orientation) {
            final isLandscape = orientation == Orientation.landscape;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFBCFE8),
                    Color(0xFFFEF9C3),
                    Color(0xFFCFFAFE),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
              ),
              child: AnimationLimiter(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: isLandscape
                      ? BuildLanscapeLayout(context: context)
                      : BuildPortraitLayout(context: context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

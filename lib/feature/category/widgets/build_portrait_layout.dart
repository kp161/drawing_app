import 'package:drawing_app/feature/category/widgets/build_container.dart';
import 'package:drawing_app/feature/category/widgets/pick_image.dart';
import 'package:drawing_app/feature/drawing_canvas/ui/drawing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class BuildPortraitLayout extends StatelessWidget {
  final BuildContext context;

  const BuildPortraitLayout({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 800),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            BuildContainer(
              image: 'assets/images/start_fresh.png',
              title: 'Start Fresh',
              text: 'Grab your magic brush and start with a blank canvas!',
              color: const Color(0xFFFACC15),
              buttontxt: "Let's Draw!",
              ontap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DrawingPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            BuildContainer(
              image: 'assets/images/draw_on_photo.png',
              title: 'Draw on Photo',
              text:
                  'Doodle over your favorite photos and make them super cool!',
              color: const Color(0xFFF472B6),
              buttontxt: 'Pick a Photo',
              ontap: () => pickImage(context),
            ),
          ],
        ),
      ),
    );
  }
}

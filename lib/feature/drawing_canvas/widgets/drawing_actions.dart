import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DrawingActionButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const DrawingActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SvgPicture.asset(icon, width: 20, height: 20),
      ),
    );
  }
}

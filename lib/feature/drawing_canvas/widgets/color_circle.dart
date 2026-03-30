import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  final Color color;
  final bool selected;

  const ColorCircle({super.key, required this.color, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: selected ? Border.all(color: color, width: 3) : null,
      ),
      child: CircleAvatar(radius: 14, backgroundColor: color),
    );
  }
}
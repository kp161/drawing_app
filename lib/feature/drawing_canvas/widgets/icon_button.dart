import 'package:flutter/material.dart';

class IconButtons extends StatelessWidget {
  final IconData icon;
  final VoidCallback ontap;
  final bool isGradient;

  const IconButtons({
    super.key,
    required this.icon,
    required this.ontap,
    this.isGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isGradient
              ? const SweepGradient(
                  colors: [
                    Colors.red,
                    Colors.orange,
                    Colors.yellow,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                    Colors.red,
                  ],
                )
              : null,
          color: isGradient ? null : Colors.grey.shade200,
        ),
        child: Center(
          child: Container(
            height: 25,
            width: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(1),
            child: Icon(icon, size: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
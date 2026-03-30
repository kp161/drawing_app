import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget{
  const CustomLogo ({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Image.asset(
        'assets/images/app_logo.png',
        width: 50,
        height: 50,
        fit: BoxFit.contain,
      ),
    );
  }
}
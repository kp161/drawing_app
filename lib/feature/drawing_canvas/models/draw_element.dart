import 'dart:ui';
import 'package:flutter/material.dart';

abstract class DrawElement {
  const DrawElement();
  void paint(Canvas canvas);
}

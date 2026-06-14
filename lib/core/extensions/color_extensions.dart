import 'package:flutter/material.dart';

extension ColorHex on Color {
  String toSvgHex() {
    final ri = (r * 255).round();
    final gi = (g * 255).round();
    final bi = (b * 255).round();
    return '#${ri.toRadixString(16).padLeft(2, '0')}'
        '${gi.toRadixString(16).padLeft(2, '0')}'
        '${bi.toRadixString(16).padLeft(2, '0')}';
  }
}

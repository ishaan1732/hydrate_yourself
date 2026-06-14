import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/color_extensions.dart';

enum CupIconType { small, mug, glass, bottle }

class CupSizeIcon extends StatelessWidget {
  const CupSizeIcon({
    super.key,
    required this.type,
    this.size = 36,
    required this.buttonBackground,
  });

  final CupIconType type;
  final double size;
  final Color buttonBackground;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final body  = isDark ? '#dbeafe' : '#93c5fd';
    final water = isDark ? '#2563eb' : '#1d4ed8';
    final rim   = isDark ? '#bfdbfe' : '#60a5fa';
    final cap   = isDark ? '#60a5fa' : '#3b82f6';
    final hole  = buttonBackground.toSvgHex();

    final svg = switch (type) {
      CupIconType.small  => _smallCupSvg(body, water, rim),
      CupIconType.mug    => _coffeeMugSvg(body, water, rim, hole),
      CupIconType.glass  => _tallGlassSvg(body, water, rim),
      CupIconType.bottle => _waterBottleSvg(body, water, rim, cap),
    };

    return SvgPicture.string(
      svg,
      width: size,
      height: size,
    );
  }
}

String _smallCupSvg(String body, String water, String rim) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <path d="M10,21 L54,21 L50,53 L14,53 Z" fill="$body"/>
  <rect x="8" y="17" width="48" height="6" rx="3" fill="$rim"/>
  <path d="M13,34 L51,34 L50,53 L14,53 Z" fill="$water"/>
  <line x1="13" y1="34" x2="51" y2="34"
        stroke="$rim" stroke-width="2" stroke-linecap="round"/>
</svg>''';

String _coffeeMugSvg(String body, String water, String rim, String hole) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <path d="M7,19 L44,19 L41,53 L10,53 Z" fill="$body"/>
  <rect x="5" y="15" width="42" height="6" rx="3" fill="$rim"/>
  <path d="M44,25 C62,25 62,47 44,47" fill="none"
        stroke="$body" stroke-width="9" stroke-linecap="round"/>
  <path d="M44,31 C55,31 55,41 44,41" fill="none"
        stroke="$hole" stroke-width="5" stroke-linecap="round"/>
  <path d="M9,34 L42,34 L41,53 L10,53 Z" fill="$water"/>
  <line x1="9" y1="34" x2="42" y2="34"
        stroke="$rim" stroke-width="2" stroke-linecap="round"/>
</svg>''';

String _tallGlassSvg(String body, String water, String rim) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <path d="M20,7 L44,7 L42,58 L22,58 Z" fill="$body"/>
  <rect x="18" y="4" width="28" height="6" rx="3" fill="$rim"/>
  <path d="M21,27 L43,27 L42,58 L22,58 Z" fill="$water"/>
  <line x1="21" y1="27" x2="43" y2="27"
        stroke="$rim" stroke-width="2" stroke-linecap="round"/>
</svg>''';

String _waterBottleSvg(String body, String water, String rim, String cap) => '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 64 64">
  <path d="M23,5 L41,5 L41,13 L40,13 L40,19
           Q50,21 50,29 L50,49
           Q50,59 32,59
           Q14,59 14,49 L14,29
           Q14,21 24,19 L24,13 L23,13 Z" fill="$body"/>
  <rect x="23" y="5" width="18" height="9" rx="3.5" fill="$cap"/>
  <rect x="25" y="10" width="14" height="2.5" rx="1.25"
        fill="$rim" opacity="0.6"/>
  <path d="M14,35 L50,35 L50,49
           Q50,58 32,58
           Q14,58 14,49 Z" fill="$water"/>
  <line x1="14" y1="35" x2="50" y2="35"
        stroke="$rim" stroke-width="2" stroke-linecap="round"/>
</svg>''';

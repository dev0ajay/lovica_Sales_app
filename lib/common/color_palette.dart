import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'font_palette.dart';

class ColorPalette {
  static Color get primaryColor => const Color(0xFF000000);

  static Color get secondaryColor => const Color(0xFF000000);

  static Color get shimmerHighlightColor => const Color(0xFFEDF5F5);

  static Color get shimmerBaseColor => const Color(0xFFF4F7F7);
  static Color get boxGrey => const Color(0xFFF3F3F3);
  static const MaterialColor materialPrimary = MaterialColor(
    0xFF000000,
    <int, Color>{
      50: Color(0xFF000000),
      100: Color(0xFF000000),
      200: Color(0xFF000000),
      300: Color(0xFF000000),
      400: Color(0xFF000000),
      500: Color(0xFF000000),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
  static const MaterialColor materialGrey = MaterialColor(
    0xFF6D737D,
    <int, Color>{
      50: Color(0xFF6D737D),
      100: Color(0xFF6D737D),
      200: Color(0xFF6D737D),
      300: Color(0xFF6D737D),
      400: Color(0xFF6D737D),
      500: Color(0xFF6D737D),
      600: Color(0xFF6D737D),
      700: Color(0xFF6D737D),
      800: Color(0xFF6D737D),
      900: Color(0xFF6D737D),
    },
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

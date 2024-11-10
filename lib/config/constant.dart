import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ThemeData(
      colorScheme: ColorScheme.light(
        surface: Colors.white,
        primary: const Color(0xFF82BC00),
        onPrimary: const Color(0xFFAAF724),
        secondary: const Color(0xFF346BC3),
        tertiary: Colors.black,
        inversePrimary: Colors.grey.shade500,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(textTheme).copyWith(
        bodyMedium: GoogleFonts.poppins(textStyle: textTheme.bodyMedium),
        bodyLarge: GoogleFonts.poppins(textStyle: textTheme.bodyLarge),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

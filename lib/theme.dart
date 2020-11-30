import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF629C44),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFF629C44),
  accentColor: const Color(0xFF629C44),
  scaffoldBackgroundColor: const Color(0xFFFFFAFA),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
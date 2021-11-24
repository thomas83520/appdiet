import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  appBarTheme: AppBarTheme(color: const Color(0xFF629C44)),
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF629C44),
  primaryColorLight: const Color(0xFF60A561),
  primaryColor: const Color(0xFF629C44),
  scaffoldBackgroundColor: const Color(0xFFFFFAFA),
  focusColor: const Color(0xFFFFC43D),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  // ignore: deprecated_member_use
  //buttonColor: Color(0xFF62C370), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.blue)
 
);


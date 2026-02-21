import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesktopTheme {
  static const Color primaryColor = Color(0xFF6B46C1);
  static const Color accentColor = Color(0xFF9333EA);
  static const Color darkBackground = Color(0xFF1F1F1F);
  static const Color sidebarBackground = Color(0xFF141414);
  static const Color cardBackground = Color(0xFF2C2C2C);
  
  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: accentColor,
      surface: cardBackground,
      background: darkBackground,
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardTheme(
      color: cardBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: sidebarBackground,
    ),
  );

  static ThemeData get lightTheme => ThemeData.light().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[50],
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: accentColor,
      surface: Colors.white,
      background: Colors.grey[50]!,
      onSurface: Colors.black87,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black54,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
  );
}

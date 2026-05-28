import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryPurple = Color(0xFF7C3AED);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color successGreen = Color(0xFF10B981);

  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkSurface = Color(0xFF334155);

  static const Color lightBg = Color(0xFFF8FAFC);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryPurple,
        secondary: AppColors.secondaryBlue,
        surface: AppColors.darkCard,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.darkBg,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkCard.withValues(alpha: 0.85),
        indicatorColor: AppColors.primaryPurple.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPurple,
            );
          }
          return TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedColor: AppColors.primaryPurple.withValues(alpha: 0.25),
        labelStyle: const TextStyle(color: Colors.white70),
        side: BorderSide(color: AppColors.darkSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[800],
        thickness: 0.5,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryPurple,
        secondary: AppColors.secondaryBlue,
        surface: AppColors.lightCard,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.lightBg,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightCard.withValues(alpha: 0.85),
        indicatorColor: AppColors.primaryPurple.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryPurple,
            );
          }
          return TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[100],
        selectedColor: AppColors.primaryPurple.withValues(alpha: 0.12),
        labelStyle: TextStyle(color: Colors.grey[700]),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        hintStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey[200],
        thickness: 0.5,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Colors.grey[900]),
        bodyMedium: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}

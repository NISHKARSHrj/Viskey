import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    scaffoldBackgroundColor: AppColors.bcg,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: Colors.black,
      secondary: AppColors.primary,
      surface: AppColors.surface,
      onSurface: AppColors.textprimary,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bcg,
      foregroundColor: AppColors.textprimary,
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppColors.border,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textprimary,
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(
          color: AppColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: AppColors.border,
      thickness: 1,
    ),
  );
}
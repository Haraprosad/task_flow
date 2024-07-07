import 'package:flutter/material.dart';
import 'package:task_flow/core/theme/app_colors.dart';
import 'package:task_flow/core/theme/app_text_styles.dart';
import 'package:task_flow/core/theme/app_theme.dart';

class ThemeConfig {
  static final Map<AppTheme, ThemeData> themeData = {
    AppTheme.lightBlue: _getLightBlueTheme(),
    AppTheme.darkBlue: _getDarkBlueTheme(),
    AppTheme.lightGreen: _getLightGreenTheme(),
    AppTheme.darkGreen: _getDarkGreenTheme(),
    AppTheme.purple: _getPurpleTheme(),
  };

  static ThemeData _getLightBlueTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.light,
    );
    return _getThemeData(colorScheme);
  }

  static ThemeData _getDarkBlueTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.blue,
      brightness: Brightness.dark,
    );
    return _getThemeData(colorScheme);
  }

  static ThemeData _getLightGreenTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: Brightness.light,
    );
    return _getThemeData(colorScheme);
  }

  static ThemeData _getDarkGreenTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.green,
      brightness: Brightness.dark,
    );
    return _getThemeData(colorScheme);
  }

  static ThemeData _getPurpleTheme() {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: Colors.purple,
      brightness: Brightness.light,
    );
    return _getThemeData(colorScheme);
  }

  static ThemeData _getThemeData(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: colorScheme.onSurface),
        displayMedium: AppTextStyles.displayMedium.copyWith(color: colorScheme.onSurface),
        displaySmall: AppTextStyles.displaySmall.copyWith(color: colorScheme.onSurface),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: colorScheme.onSurface),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: colorScheme.onSurface),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(color: colorScheme.onSurface),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: colorScheme.onSurface),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: colorScheme.onSurface),
        titleSmall: AppTextStyles.titleSmall.copyWith(color: colorScheme.onSurface),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: colorScheme.onSurface),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: colorScheme.onSurface),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: colorScheme.onSurface),
        labelMedium: AppTextStyles.labelMedium.copyWith(color: colorScheme.onSurface),
        labelSmall: AppTextStyles.labelSmall.copyWith(color: colorScheme.onSurface),
      ),
    );
  }
}
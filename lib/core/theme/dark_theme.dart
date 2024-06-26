// dark_theme.dart
import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';

final TextTheme darkTextTheme = TextTheme(
  displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.white),
  displayMedium: AppTextStyles.displayMedium.copyWith(color: Colors.white),
  displaySmall: AppTextStyles.displaySmall.copyWith(color: Colors.white),
  headlineLarge: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
  headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
  headlineSmall: AppTextStyles.headlineSmall.copyWith(color: Colors.white),
  titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.white70),
  titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.white70),
  titleSmall: AppTextStyles.titleSmall.copyWith(color: Colors.white70),
  bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
  bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
  bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
  labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.black),
  labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.black),
  labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.black),
);

final ThemeData customDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
  textTheme: darkTextTheme,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[900],
    textTheme: ButtonTextTheme.primary,
  ),
);

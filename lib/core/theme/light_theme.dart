// light_theme.dart
import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_text_styles.dart';

final TextTheme lightTextTheme = TextTheme(
  displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.black),
  displayMedium: AppTextStyles.displayMedium.copyWith(color: Colors.black),
  displaySmall: AppTextStyles.displaySmall.copyWith(color: Colors.black),
  headlineLarge: AppTextStyles.headlineLarge.copyWith(color: Colors.black),
  headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.black),
  headlineSmall: AppTextStyles.headlineSmall.copyWith(color: Colors.black),
  titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.black87),
  titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.black87),
  titleSmall: AppTextStyles.titleSmall.copyWith(color: Colors.black87),
  bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Colors.black87),
  bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.black87),
  bodySmall: AppTextStyles.bodySmall.copyWith(color: Colors.black87),
  labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.white),
  labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.white),
  labelSmall: AppTextStyles.labelSmall.copyWith(color: Colors.white),
);

final ThemeData customLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  textTheme: lightTextTheme,
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[200],
    textTheme: ButtonTextTheme.primary,
  ),
);

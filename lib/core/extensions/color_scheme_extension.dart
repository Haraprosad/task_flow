import 'package:flutter/material.dart';

extension ColorSchemeExtension on BuildContext {
  Color get errorColor => Theme.of(this).colorScheme.error;
  Color get primaryColor => Theme.of(this).colorScheme.primary;
}
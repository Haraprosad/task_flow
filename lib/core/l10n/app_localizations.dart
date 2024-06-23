import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';

class AppLocalizations {
  // Private constructor to prevent instantiation
  AppLocalizations._();

  // Supported locales
  static const Locale englishLocale = Locale('en', 'US');
  static const Locale bengaliLocale = Locale('bn', 'BD');

  static const List<Locale> _supportedLocales = [
    englishLocale,
    bengaliLocale,
  ];

  static List<Locale> getSupportedLocales() => _supportedLocales;

  // Local file path
  static const String localPath = 'assets/translations';

  // Fallback and start locales
  static const Locale fallbackLocale = Locale('en', 'US');
  static const Locale startLocale = Locale('en', 'US');

  /// Changes the locale of the app.
  static void changeLocale(BuildContext context, Locale locale) {
    if (_supportedLocales.contains(locale)) {
      context.setLocale(locale);
    } else {
      logger.e('Unsupported locale: $locale');
      // Optionally, set to fallback locale
      context.setLocale(fallbackLocale);
    }
  }

  /// Returns the device locale if supported, otherwise returns the fallback locale.
  static Locale getDefaultLocale(BuildContext context) {
    final deviceLocale = context.deviceLocale;
    return _supportedLocales.contains(deviceLocale)
        ? deviceLocale
        : fallbackLocale;
  }
}

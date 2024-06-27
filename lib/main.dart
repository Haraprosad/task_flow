import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/config/observers/bloc_observer.dart';
import 'package:task_flow/core/constants/key_constants.dart';
import 'package:task_flow/core/di/injection.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';
import 'package:task_flow/core/router/app_router.dart';
import 'package:task_flow/core/l10n/app_localizations.dart';
import 'package:task_flow/core/theme/theme_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:task_flow/flavors/env_config.dart';
import 'package:task_flow/flavors/environment.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    //Environment part
    await dotenv.load(fileName: KeyConstants.envProduction);

    EnvConfig.instantiate(
        baseUrl: dotenv.env[KeyConstants.envKeyBaseUrl]!,
        token: dotenv.env[KeyConstants.envKeyToken]!,
        todoSectionId: dotenv.env[KeyConstants.envKeyTodoSectionId]!,
        inProgressSectionId:
            dotenv.env[KeyConstants.envKeyInProgressSectionId]!,
        doneSectionId: dotenv.env[KeyConstants.envKeyDoneSectionId]!,
        environmentType: EnvironmentType.PRODUCTION);

    // Initialize logger
    await EasyLocalization.ensureInitialized();
    configureDependencies();

    // Set the global Bloc observer
    Bloc.observer = AppBlocObserver();

    runApp(
      EasyLocalization(
        supportedLocales: AppLocalizations.getSupportedLocales(),
        startLocale: AppLocalizations.startLocale,
        fallbackLocale: AppLocalizations.fallbackLocale,
        path: AppLocalizations.localPath,
        child: const MyApp(),
      ),
    );
  }, (exception, stackTrace) async {
    if (kReleaseMode) {
      //! Log to Firebase Crashlytics
      //FirebaseCrashlytics.instance.recordError(exception, stackTrace);
    } else {
      //! Log to console in debug or profile mode
      logger.e("Unhandled error: $exception",
          error: exception, stackTrace: stackTrace);
    }
  });

  // Handle Flutter framework errors
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {
      //FirebaseCrashlytics.instance.recordFlutterError(details);
    } else {
      logger.e("Flutter error: ${details.exception}",
          error: details.exception, stackTrace: details.stack);
    }
  };

  // Handle platform/OS errors
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    if (kReleaseMode) {
      //FirebaseCrashlytics.instance.recordError(error, stack);
    } else {
      logger.e("Platform error: $error", error: error, stackTrace: stack);
    }
    return true;
  };

  // Customize the error widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(LocalizationConstants.unknownErrorTitle).tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              LocalizationConstants.unknownError,
              style: TextStyle(fontSize: 18, color: Colors.black),
              textAlign: TextAlign.center,
            ).tr(),
            const SizedBox(height: 8),
            const Text(
              LocalizationConstants.tryAgainLater,
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ).tr(),
          ],
        ),
      ),
    );
  };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (_, child) {
          return MaterialApp.router(
            title: "Task Flow",
            routerConfig: AppRouter.routerConfig,
            theme: ThemeConfig.lightTheme,
            darkTheme: ThemeConfig.darkTheme,
            themeMode: ThemeMode.system,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        });
  }
}

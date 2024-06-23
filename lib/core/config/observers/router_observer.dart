import 'package:flutter/material.dart';
import '../loggers/logger_mixin.dart';

class AppRouterObserver extends NavigatorObserver with LoggerMixin {
  @override
  String get logPrefix => 'router-observer';

  @override
  void didPush(Route route, Route? previousRoute) {
    debugLog('didPush -- route: ${route.settings.name}, previousRoute: ${previousRoute?.settings.name}');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    debugLog('didPop -- route: ${route.settings.name}, previousRoute: ${previousRoute?.settings.name}');
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    debugLog('didReplace -- newRoute: ${newRoute?.settings.name}, oldRoute: ${oldRoute?.settings.name}');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    debugLog('didRemove -- route: ${route.settings.name}, previousRoute: ${previousRoute?.settings.name}');
    super.didRemove(route, previousRoute);
  }
}

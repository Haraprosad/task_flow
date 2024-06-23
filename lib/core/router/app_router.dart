import 'package:go_router/go_router.dart';
import 'package:task_flow/core/config/observers/router_observer.dart';
import 'package:task_flow/core/router/app_routes.dart';
import 'package:task_flow/core/router/route_paths.dart';

class AppRouter {
  static final GoRouter _routerConfig = GoRouter(
    initialLocation: RoutePaths.home,
    routes: appRoutes,
    observers: [AppRouterObserver()],
  );

  static GoRouter get routerConfig => _routerConfig;
}
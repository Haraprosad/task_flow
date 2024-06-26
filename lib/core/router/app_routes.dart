import 'package:go_router/go_router.dart';
import 'package:task_flow/core/router/route_names.dart';
import 'package:task_flow/core/router/route_paths.dart';
import 'package:task_flow/features/home/presentation/pages/home_page.dart';
import 'package:task_flow/features/kanban_board/presentation/pages/kanban_board_screen.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/kanban_board.dart';
import 'package:task_flow/main.dart';

final List<GoRoute> appRoutes = [
  GoRoute(
        path: RoutePaths.kanbanBoard,
        name: RouteNames.kanbanBoard,
        builder: (context, state) => KanbanBoardScreen(),
      ),
  GoRoute(
    path: RoutePaths.home,
    name: RouteNames.home,
    builder: (context, state) => HomePage(),
  ),
];

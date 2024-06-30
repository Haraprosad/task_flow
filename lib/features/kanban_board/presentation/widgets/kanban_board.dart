import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/kanban_section.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/task_dialog.dart';
import 'package:task_flow/flavors/env_config.dart';

class KanbanBoard extends StatefulWidget {
  @override
  _KanbanBoardState createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KanbanBoardBloc, KanbanBoardState>(
      builder: (context, state) {
        if (state is KanbanBoardLoaded) {
          return _buildKanbanBoard(context, state.tasks);
        } else if (state is KanbanBoardLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is KanbanBoardError) {
          return Center(child: Text(state.message));
        }
        return Center(child: Text('Something went wrong'));
      },
    );
  }

  Widget _buildKanbanBoard(BuildContext context, List<TaskEntity> tasks) {
    final EnvConfig envConfig = EnvConfig.instance;
    final sections = [
      SectionConfig('To Do', envConfig.todoSectionId),
      SectionConfig('In Progress', envConfig.inProgressSectionId),
      SectionConfig('Done', envConfig.doneSectionId),
    ];

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: sections.map((section) => Tab(text: section.title)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: sections.map((section) {
          return DragTarget<TaskEntity>(
            builder: (context, candidateData, rejectedData) {
              return KanbanSection(
                title: section.title,
                sectionId: section.id,
                tasks: tasks
                    .where((task) => task.sectionId == section.id)
                    .toList(),
                onDragAction: (task, horizontalPosition, isRightDirection) =>
                    _handleDragAction(context: context,task: task, 
                    horizontalPosition :horizontalPosition,
                        currentSectionId:section.id,
                        isRightDirection: isRightDirection ),
                onEditTask: (task) => _showEditTaskDialog(context, task),
              );
            },
            onWillAccept: (data) {
              return true;
              //return data != null && data.sectionId != section.id;
            },
            onAccept: (data) {
              context.read<KanbanBoardBloc>().add(
                    MoveTask(
                      taskId: data.id,
                      newSectionId: section.id,
                      isCompleted: section.id == envConfig.doneSectionId,
                    ),
                  );
            },
          );
        }).toList(),
      ),
    );
  }

  void _handleDragAction(
      {required BuildContext context,
      required TaskEntity task,
      required double horizontalPosition,
      required String currentSectionId,
      required bool isRightDirection,
    }) {
    logger.i("Drag Action has been called.");
    final halfScreenWidth = MediaQuery.of(context).size.width / 2;
    final dragX = horizontalPosition.abs();

    if (dragX > halfScreenWidth) {
      final EnvConfig envConfig = EnvConfig.instance;
      final sections = [
        envConfig.todoSectionId,
        envConfig.inProgressSectionId,
        envConfig.doneSectionId,
      ];

      int nextIndex;
      if (isRightDirection && _currentIndex < 2) {
        nextIndex = _currentIndex + 1;
      } else if (!isRightDirection && _currentIndex > 0) {
        nextIndex = _currentIndex - 1;
      } else {
        return; // Don't move if we're at the edges
      }

      final newSectionId = sections[nextIndex];
      // if (newSectionId != currentSectionId) {
      //   context.read<KanbanBoardBloc>().add(
      //         MoveTask(
      //           taskId: task.id,
      //           newSectionId: newSectionId,
      //           isCompleted: newSectionId == envConfig.doneSectionId,
      //         ),
      //       );
      // }

      _tabController.animateTo(nextIndex);
    }
  }

  void _showEditTaskDialog(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (BuildContext context) => TaskDialog(
        task: task,
        onSave: (updatedTask) {
          context.read<KanbanBoardBloc>().add(UpdateExistingTask(task));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

class SectionConfig {
  final String title;
  final String id;

  SectionConfig(this.title, this.id);
}

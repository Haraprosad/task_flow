import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/core/constants/key_constants.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';
import 'package:task_flow/core/widgets/error_showing_widget.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/app_drawer.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/kanban_section.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/task_dialog.dart';
import 'package:task_flow/core/utils/easyloading_util.dart';

class KanbanBoard extends StatefulWidget {
    KanbanBoard({Key? key}) : super(key: key);

  @override
  _KanbanBoardState createState() => _KanbanBoardState();
}

class _KanbanBoardState extends State<KanbanBoard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  Locale? _currentLocale;

  final List<SectionConfig> sections = [
    SectionConfig(LocalizationConstants.todo, KeyConstants.todoSectionId),
    SectionConfig(
        LocalizationConstants.inProgress, KeyConstants.inProgressSectionId),
    SectionConfig(LocalizationConstants.done, KeyConstants.doneSectionId),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: sections.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = context.locale;
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      setState(() {}); 
    }
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
    return BlocConsumer<KanbanBoardBloc, KanbanBoardState>(
      builder: (context, state) {
        if (state is KanbanBoardLoaded) {
          return _buildKanbanBoard(context, state.tasks);
        } else if (state is KanbanBoardError) {
          return ErrorShowingWidget(
            errorMessage: state.message,
            onRetry: () {
              context.read<KanbanBoardBloc>().add(const LoadTasks(""));
            },
          );
        }
        return Container();
      },
      listener: (BuildContext context, KanbanBoardState state) {
        _handleStateChange(state);
      },
    );
  }

  Widget _buildKanbanBoard(BuildContext context, List<TaskEntity> tasks) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: sections
            .map((section) => _buildSection(context, section, tasks))
            .toList(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(LocalizationConstants.kanbanBoard).tr(),
      bottom: TabBar(
        controller: _tabController,
        tabs: sections.map((section) => Tab(text: section.title.tr())).toList(),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, SectionConfig section, List<TaskEntity> tasks) {
    return KanbanSection(
          title: section.title,
          sectionId: section.id,
          onUpdateTask: _updateTask,
          tasks: tasks.where((task) => task.sectionId == section.id).toList(),
          onDragAction: (task, horizontalPosition, isRightDirection) =>
              _handleDragAction(
            context: context,
            task: task,
            horizontalPosition: horizontalPosition,
            currentSectionId: section.id,
            isRightDirection: isRightDirection,
          ),
          onEditTask: (task) => _showEditTaskDialog(context, task),
        );
      
  }

  void _updateTask(TaskEntity updatedTask) {
    context.read<KanbanBoardBloc>().add(UpdateExistingTask(updatedTask));
  }

  void _handleDragAction({
    required BuildContext context,
    required TaskEntity task,
    required double horizontalPosition,
    required String currentSectionId,
    required bool isRightDirection,
  }) {
    final halfScreenWidth = MediaQuery.of(context).size.width / 2;
    final dragX = horizontalPosition.abs();

    if (dragX > halfScreenWidth) {
      int nextIndex = _getNextIndex(isRightDirection);
      if (nextIndex != _currentIndex) {
        _moveTask(task, sections[nextIndex].id);
        _tabController.animateTo(nextIndex);
      }
    }
  }

  int _getNextIndex(bool isRightDirection) {
    if (isRightDirection && _currentIndex < sections.length - 1) {
      return _currentIndex + 1;
    } else if (!isRightDirection && _currentIndex > 0) {
      return _currentIndex - 1;
    }
    return _currentIndex;
  }

  void _moveTask(TaskEntity task, String newSectionId) {
    final newTask = newSectionId == KeyConstants.doneSectionId
        ? task.copyWith(
            sectionId: newSectionId,
            isCompleted: true,
            completedAt: DateTime.now(),
          )
        : task.copyWith(sectionId: newSectionId);

    context.read<KanbanBoardBloc>().add(MoveTask(newTaskEntity: newTask));
  }

  void _showEditTaskDialog(BuildContext context, TaskEntity task) {
    showDialog(
      context: context,
      builder: (BuildContext context) => TaskDialog(
        task: task,
        onSave: (updatedTask) {
          _updateTask(updatedTask);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _handleStateChange(KanbanBoardState state) {
    if (state is KanbanBoardError) {
      stopLoading();
      showErrorMessage(message: state.message);
    } else if (state is KanbanBoardLoading || state is KanbanBoardInitial) {
      showLoading(message: LocalizationConstants.loadingTasks.tr());
    } else {
      stopLoading();
    }
  }
}

class SectionConfig {
  final String title;
  final String id;

  SectionConfig(this.title, this.id);
}

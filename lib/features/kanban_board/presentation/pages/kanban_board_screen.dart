import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/kanban_board.dart';
import 'package:task_flow/flavors/env_config.dart';
import 'package:uuid/uuid.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the KanbanBoardBloc
    final kanbanBoardBloc = context.read<KanbanBoardBloc>();
    final EnvConfig envConfig = EnvConfig.instance;
    final String todoSectionId = envConfig.todoSectionId;

    // Load tasks when the screen is built
    kanbanBoardBloc.add(const LoadTasks(""));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board'),
      ),
      body: KanbanBoard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context: context,sectionId: todoSectionId),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog({required BuildContext context,required String sectionId}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String taskTitle = '';
        return AlertDialog(
          title: const Text('Add New Task'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter task title',
            ),
            onChanged: (value) {
              taskTitle = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (taskTitle.isNotEmpty) {
                  final newTask = TaskEntity(
                    id: const Uuid().v4(),
                    content: taskTitle,
                    sectionId:sectionId,
                  );
                  context.read<KanbanBoardBloc>().add(AddNewTask(newTask));
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/kanban_board.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/task_dialog.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  KanbanBoard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => TaskDialog(
        onSave: (updatedTask) {
          context.read<KanbanBoardBloc>().add(AddNewTask(updatedTask));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}

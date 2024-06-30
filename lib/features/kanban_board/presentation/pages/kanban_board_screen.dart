import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_flow/core/constants/key_constants.dart';
import 'package:task_flow/core/extensions/color_scheme_extension.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/presentation/bloc/kanban_board_bloc.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/bulleted_text_field.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/kanban_board.dart';
import 'package:uuid/uuid.dart';

class KanbanBoardScreen extends StatelessWidget {
  const KanbanBoardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kanbanBoardBloc = context.read<KanbanBoardBloc>();
    kanbanBoardBloc.add(const LoadTasks(""));

    return Scaffold(
      body: KanbanBoard(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(
            context: context, sectionId: KeyConstants.todoSectionId),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(
      {required BuildContext context, required String sectionId}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        String taskTitle = '';
        List<String> comments = [];
        return AlertDialog(
          title: Text('Add New Task', style: context.titleLarge),
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Task Title', style: context.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Enter task title',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2.0),
                      ),
                    ),
                    onChanged: (value) {
                      taskTitle = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('Comments', style: context.titleMedium),
                  const SizedBox(height: 8),
                  BulletTextField(
                    onChanged: (value) {
                      comments = value;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  Text('Cancel', style: TextStyle(color: context.errorColor)),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add'),
              onPressed: () {
                if (taskTitle.isNotEmpty) {
                  final newTask = TaskEntity(
                    id: const Uuid().v4(),
                    content: taskTitle,
                    sectionId: sectionId,
                    comments: comments,
                    duration: 0,
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


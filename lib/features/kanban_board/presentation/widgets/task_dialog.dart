import 'package:flutter/material.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

class TaskDialog extends StatefulWidget {
  final TaskEntity? task;
  final Function(TaskEntity) onSave;

  const TaskDialog({Key? key, this.task, required this.onSave}) : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task?.content);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: 'Task Title'),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(widget.task == null ? 'Add' : 'Save'),
          onPressed: () {
            final updatedTask = widget.task?.copyWith(content: _controller.text) ??
                TaskEntity(
                  id: DateTime.now().toString(),
                  content: _controller.text,
                  sectionId: '', // Set appropriate default section
                );
            widget.onSave(updatedTask);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
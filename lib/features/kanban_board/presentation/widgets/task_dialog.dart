import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/key_constants.dart';
import 'package:task_flow/core/extensions/color_scheme_extension.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/bulleted_text_field.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class TaskDialog extends StatefulWidget {
  final TaskEntity? task;
  final Function(TaskEntity) onSave;

  const TaskDialog({Key? key, this.task, required this.onSave})
      : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late List<String> _comments;
  DateTime? _dueDateTime;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.content);
    _comments = widget.task?.comments ?? [];
    _dueDateTime = widget.task?.due;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add New Task' : 'Edit Task',
          style: context.titleLarge),
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
                controller: _titleController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter task title',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Due Date and Time', style: context.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDateTime(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _dueDateTime != null
                            ? DateFormat('MMM dd, yyyy HH:mm').format(_dueDateTime!)
                            : 'Select due date and time',
                      ),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Comments', style: context.titleMedium),
              const SizedBox(height: 8),
              BulletTextField(
                initialComments: _comments,
                onChanged: (value) {
                  _comments = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel', style: TextStyle(color: context.errorColor)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(widget.task == null ? 'Add' : 'Save'),
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final updatedTask = widget.task?.copyWith(
                    content: _titleController.text,
                    comments: _comments,
                    due: _dueDateTime,
                  ) ??
                  TaskEntity(
                    id: widget.task?.id ?? const Uuid().v4(),
                    content: _titleController.text,
                    sectionId: widget.task?.sectionId ?? KeyConstants.todoSectionId,
                    comments: _comments,
                    duration: 0,
                    due: _dueDateTime,
                  );
              widget.onSave(updatedTask);
            }
          },
        ),
      ],
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dueDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_dueDateTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _dueDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
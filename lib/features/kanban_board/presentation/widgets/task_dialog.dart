import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/key_constants.dart';
import 'package:task_flow/core/extensions/color_scheme_extension.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';
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
  final FocusNode _titleFocusNode = FocusNode();

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
      title: Text(
          widget.task == null
              ? LocalizationConstants.addNewTask.tr()
              : LocalizationConstants.editTask.tr(),
          style: context.titleLarge),
      content: SingleChildScrollView(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(LocalizationConstants.taskTitle.tr(),
                  style: context.titleMedium),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                autofocus: false,
                focusNode: _titleFocusNode,
                decoration: InputDecoration(
                  hintText: LocalizationConstants.enterTaskTitle.tr(),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).primaryColor, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(LocalizationConstants.dueDate.tr(),
                  style: context.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectDateTime(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _dueDateTime != null
                            ? DateFormat('MMM dd, yyyy HH:mm')
                                .format(_dueDateTime!)
                            : LocalizationConstants.selectDateAndTime.tr(),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(LocalizationConstants.comments.tr(),
                  style: context.titleMedium),
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
          child: Text(LocalizationConstants.cancel.tr(),
              style: TextStyle(color: context.colorScheme.error)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          child: Text(widget.task == null
              ? LocalizationConstants.add.tr()
              : LocalizationConstants.save.tr()),
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
                    sectionId:
                        widget.task?.sectionId ?? KeyConstants.todoSectionId,
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
    _titleFocusNode.unfocus();
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
    _titleFocusNode.dispose();
    super.dispose();
  }
}

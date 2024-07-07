import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/constants/app_spacing.dart';
import 'package:task_flow/core/constants/key_constants.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/core/l10n/localization_constants.dart';
import 'package:task_flow/core/utils/format_time.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

class DraggableTaskCard extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onEdit;
  final Function(double, bool, int) onDragAction;
  final Function(TaskEntity) onUpdateTask;

  DraggableTaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDragAction,
    required this.onUpdateTask,
  }) : super(key: key);

  @override
  State<DraggableTaskCard> createState() => _DraggableTaskCardState();
}

class _DraggableTaskCardState extends State<DraggableTaskCard> {
  bool isTheresholdExceeded = true;
  double horizontalPosition = 0.0;
  int durationTime = 0;

  @override
  void initState() {
    isTheresholdExceeded = false;
    horizontalPosition = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<TaskEntity>(
      delay: const Duration(milliseconds: 300),
      data: widget.task,
      axis: Axis.horizontal,
      onDragUpdate: (details) {
        DragUpdateDetails detailsx = details;

        horizontalPosition = detailsx.localPosition.dx;

        if (!isTheresholdExceeded) {
          bool isRightDirection = detailsx.delta.dx > 0;
          widget.onDragAction(horizontalPosition, isRightDirection, durationTime);
        }

        isTheresholdExceeded =
            detailsx.localPosition.dx > MediaQuery.of(context).size.width / 2;
      },

      // onDragEnd: onDragEnd,
      feedback: Material(
        elevation: 4.0,
        child: Container(
          width: 300.w,
          padding: EdgeInsets.all(AppSpacing.paddingSmallW),
          child: Text(widget.task.content),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: TaskCard(
          task: widget.task,
          onEdit: widget.onEdit,
          onUpdateTask: widget.onUpdateTask,
          onUpdateTime: (time) {
            durationTime = time;
          },
        ),
      ),
      child: TaskCard(
        task: widget.task,
        onEdit: widget.onEdit,
        onUpdateTask: widget.onUpdateTask,
        onUpdateTime: (time) {
          durationTime = time;
        },
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onEdit;
  final Function(TaskEntity) onUpdateTask;
  final Function(int) onUpdateTime;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onUpdateTask,
    required this.onUpdateTime,
  }) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  Timer? _timer;
  late int _seconds;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _seconds = widget.task.duration;
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.task.sectionId != oldWidget.task.sectionId) {
      if (widget.task.sectionId != KeyConstants.inProgressSectionId) {
        _stopTimer();
      }
    }
  }

  void _toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
      widget.onUpdateTime(_seconds);
     
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    widget.onUpdateTime(_seconds);
    widget.onUpdateTask(widget.task.copyWith(duration: _seconds));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.task.content,
                    style: context.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  onPressed: widget.onEdit,
                  tooltip: LocalizationConstants.editTask.tr(),
                ),
              ],
            ),
            if (widget.task.due != null &&
                widget.task.sectionId != KeyConstants.doneSectionId)
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  '${LocalizationConstants.dueDate.tr()}: ${widget.task.due}',
                  style: context.bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Text(
                    '${LocalizationConstants.time.tr()}: ${formatTime(_seconds)}',
                    style: context.bodyMedium,
                  ),
                  SizedBox(width: 8),
                  if (widget.task.sectionId == KeyConstants.inProgressSectionId)
                    IconButton(
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      onPressed: _toggleTimer,
                      tooltip: _isRunning
                          ? LocalizationConstants.pauseTimer.tr()
                          : LocalizationConstants.startTimer.tr(),
                    ),
                ],
              ),
            ),
            if (widget.task.sectionId == KeyConstants.doneSectionId &&
                widget.task.completedAt != null)
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  '${LocalizationConstants.completed.tr()}: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.task.completedAt!)}',
                  style: context.bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            SizedBox(height: 8.0),
            if (widget.task.comments.isNotEmpty) ...[
              Text(
                '${LocalizationConstants.comments.tr()}:',
                style:
                    context.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4.0),
              ...widget.task.comments.map((comment) => Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle,
                            size: 8, color: Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(comment, style: context.bodySmall)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

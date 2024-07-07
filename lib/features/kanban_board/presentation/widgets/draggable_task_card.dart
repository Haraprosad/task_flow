import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/constants/key_constants.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

class DraggableTaskCard extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onEdit;
  final Function(double, bool) onDragAction;
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

  @override
  void initState() {
    logger.i("Init state has been called ************");
    isTheresholdExceeded = false;
    horizontalPosition = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.e("Build method has been called and ${widget.task} ************");
    return Draggable<TaskEntity>(
      data: widget.task,
      axis: Axis.horizontal,
      onDragUpdate: (details) {
        DragUpdateDetails detailsx = details;
        logger
            .e("**************Local*************${detailsx.localPosition.dx}");
        logger.e(
            "************Global***************${detailsx.globalPosition.dx}");
        logger.e("************Source***************${detailsx.delta.dx}");
        horizontalPosition = detailsx.localPosition.dx;

        logger.e(
            "************isTheresholdExceeded:$isTheresholdExceeded**************");
        if (!isTheresholdExceeded) {
          logger.e("************Method call***************");
          bool isRightDirection = detailsx.delta.dx > 0;
          widget.onDragAction(horizontalPosition, isRightDirection);
        }

        isTheresholdExceeded =
            detailsx.localPosition.dx > MediaQuery.of(context).size.width / 2;
      },

      // onDragEnd: onDragEnd,
      feedback: Material(
        elevation: 4.0,
        child: Container(
          width: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(widget.task.content),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: TaskCard(
          task: widget.task,
          onEdit: widget.onEdit,
          onUpdateTask: widget.onUpdateTask,
        ),
      ),
      child: TaskCard(
        task: widget.task,
        onEdit: widget.onEdit,
        onUpdateTask: widget.onUpdateTask,
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onEdit;
  final Function(TaskEntity) onUpdateTask;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onUpdateTask,
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
      widget.onUpdateTask(widget.task.copyWith(duration: _seconds));
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    widget.onUpdateTask(widget.task.copyWith(duration: _seconds));
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Color _getCardColor() {
    switch (widget.task.sectionId) {
      case KeyConstants.todoSectionId:
        return Colors.blue[50]!;
      case KeyConstants.inProgressSectionId:
        return Colors.amber[50]!;
      case KeyConstants.doneSectionId:
        return Colors.green[50]!;
      default:
        return Colors.white;
    }
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
      color: _getCardColor(),
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
                  tooltip: 'Edit Task',
                ),
              ],
            ),
            if (widget.task.due != null &&
                widget.task.sectionId != KeyConstants.doneSectionId)
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Due: ${widget.task.due}',
                  style: context.bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Text(
                    'Time: ${_formatTime(_seconds)}',
                    style: context.bodyMedium,
                  ),
                  SizedBox(width: 8),
                  if (widget.task.sectionId == KeyConstants.inProgressSectionId)
                    IconButton(
                      icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                      onPressed: _toggleTimer,
                      tooltip: _isRunning ? 'Pause Timer' : 'Start Timer',
                    ),
                ],
              ),
            ),
            if (widget.task.sectionId == KeyConstants.doneSectionId &&
                widget.task.completedAt != null)
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Completed: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.task.completedAt!)}',
                  style: context.bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            SizedBox(height: 8.0),
            if (widget.task.comments.isNotEmpty) ...[
              Text(
                'Comments:',
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

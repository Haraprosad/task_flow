import 'package:flutter/material.dart';
import 'package:task_flow/core/config/loggers/logger_config.dart';
import 'package:task_flow/core/extensions/text_style_extensions.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';

class DraggableTaskCard extends StatefulWidget {
  final TaskEntity task;
  final VoidCallback onEdit;
  final Function(double, bool) onDragAction;

  DraggableTaskCard({
    Key? key,
    required this.task,
    required this.onEdit,
    required this.onDragAction,
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
    logger.e("Build method has been called ************");
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
        child: TaskCard(task: widget.task, onEdit: widget.onEdit),
      ),
      child: TaskCard(task: widget.task, onEdit: widget.onEdit),
    );
  }
}

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onEdit;

  const TaskCard({Key? key, required this.task, required this.onEdit})
      : super(key: key);

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
                    task.content,
                    style: context.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                  onPressed: onEdit,
                  tooltip: 'Edit Task',
                ),
              ],
            ),
            if (task.due != null)
              Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                  'Due: ${task.due!.date}',
                  style: context.bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              ),
            SizedBox(height: 8.0),
            if (task.comments.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.comment,
                      size: 16, color: Theme.of(context).primaryColor),
                  SizedBox(width: 8),
                  Text(
                    'Comments:',
                    style: context.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 4.0),
              ...task.comments.map((comment) => Padding(
                    padding: EdgeInsets.only(left: 16.0, bottom: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.circle,
                            size: 16, color: Theme.of(context).primaryColor),
                        SizedBox(width: 8),
                        Expanded(
                            child: Text(comment, style: context.bodyMedium)),
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

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:task_flow/core/constants/app_spacing.dart';
import 'package:task_flow/features/kanban_board/domain/entities/task_entity.dart';
import 'package:task_flow/features/kanban_board/presentation/widgets/draggable_task_card.dart';

class KanbanSection extends StatelessWidget {
  final String title;
  final String sectionId;
  final List<TaskEntity> tasks;
  final Function(TaskEntity, double, bool) onDragAction;
  final Function(TaskEntity) onEditTask;
  final Function(TaskEntity) onUpdateTask;

  const KanbanSection(
      {Key? key,
      required this.title,
      required this.sectionId,
      required this.tasks,
      required this.onDragAction,
      required this.onEditTask,
      required this.onUpdateTask})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SizedBox(height: AppSpacing.sizedBoxSmallH),
        Expanded(
          child: DragTarget<TaskEntity>(
            builder: (context, candidateData, rejectedData) {
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return DraggableTaskCard(
                    task: tasks[index],
                    onUpdateTask: (onUpdatedTask) => onUpdateTask(onUpdatedTask),
                    onDragAction: (horizontalPosition, isRightDirection) =>
                        onDragAction(
                            tasks[index], horizontalPosition, isRightDirection),
                    onEdit: () => onEditTask(tasks[index]),
                  );
                },
              );
            }
          ),
        ),
      ],
    );
  }
}

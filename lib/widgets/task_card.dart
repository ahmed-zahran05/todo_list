import 'package:flutter/material.dart';
import 'package:todo_list/core/colors.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(String) onToggleComplete;
  final Function(String) onDelete;
  final Function(Task) onEdit;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: _getPriorityColor(task.priority),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.isCompleted 
                                      ? TextDecoration.lineThrough 
                                      : TextDecoration.none,
                                  color: task.isCompleted ? Colors.grey : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.appBarColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                task.category.displayName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.appBarColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            if (task.dueDate != null)
                              Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 4),
                                    Text(
                                      "${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (task.reminderTime != null)
                              Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Row(
                                  children: [
                                    Icon(Icons.alarm, size: 16, color: Colors.grey[600]),
                                    SizedBox(width: 4),
                                    Text(
                                      "${task.reminderTime!.hour}:${task.reminderTime!.minute.toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(task.priority).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                task.priority.displayName,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _getPriorityColor(task.priority),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: task.isCompleted ? Colors.green : AppColors.appBarColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 34,
                    width: 69,
                    child: GestureDetector(
                      onTap: () => onToggleComplete(task.id),
                      child: Icon(
                        task.isCompleted ? Icons.check_circle : Icons.check,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onEdit(task),
                    child: Icon(
                      Icons.edit,
                      color: Colors.blue,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onDelete(task.id),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}

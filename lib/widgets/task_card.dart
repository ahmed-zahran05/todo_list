import 'package:flutter/material.dart';
import 'package:todo_list/core/colors.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final Function(String) onToggleComplete;
  final Function(String) onDelete;

  const TaskCard({
    Key? key,
    required this.task,
    required this.onToggleComplete,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 7),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 8,
                height: 62,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(5),
                  color: task.isCompleted ? Colors.green : AppColors.appBarColor,
                ),
              ),
            ),
            SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.isCompleted 
                          ? TextDecoration.lineThrough 
                          : TextDecoration.none,
                      color: task.isCompleted ? Colors.grey : Colors.black,
                    ),
                  ),
                  if (task.dueDate != null)
                    Text(
                      "Due: ${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: task.isCompleted ? Colors.green : AppColors.appBarColor,
                      borderRadius: BorderRadiusGeometry.circular(15),
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
                    onTap: () => onDelete(task.id),
                    child: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

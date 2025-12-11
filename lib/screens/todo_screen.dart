import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/colors.dart';
import 'package:todo_list/widgets/task_card.dart';
import 'package:todo_list/widgets/task_form.dart';
import 'package:todo_list/widgets/filter_widget.dart';
import 'package:todo_list/services/task_service.dart';
import 'package:todo_list/models/task.dart';

import 'calender_screen.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskService(),
      child: Consumer<TaskService>(
        builder: (context, taskService, child) {
          return Scaffold(
            backgroundColor: AppColors.mainColor,
            appBar: AppBar(
              backgroundColor: AppColors.appBarColor,
              title: Text(
                "To Do List",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    _showFilters ? Icons.filter_list_off : Icons.filter_list,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _showFilters = !_showFilters;
                    });
                  },
                ),
              ],
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                HorizontalDatePicker(
                  onDateSelected: (date) {
                    taskService.setSelectedDate(date);
                  },
                ),
                if (_showFilters) ...[
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: FilterWidget(
                      selectedCategory: taskService.filterCategory,
                      selectedPriority: taskService.filterPriority,
                      sortOption: taskService.sortOption,
                      onCategoryChanged: (category) {
                        taskService.setFilterCategory(category);
                      },
                      onPriorityChanged: (priority) {
                        taskService.setFilterPriority(priority);
                      },
                      onSortChanged: (option) {
                        taskService.setSortOption(option);
                      },
                      onClearFilters: () {
                        taskService.clearFilters();
                      },
                    ),
                  ),
                ],
                SizedBox(height: 10),
                Expanded(
                  child: taskService.tasks.isEmpty
                      ? Center(
                          child: Text(
                            "No tasks for this day",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: taskService.tasks.length,
                          itemBuilder: (context, index) {
                            final task = taskService.tasks[index];
                            return TaskCard(
                              task: task,
                              onToggleComplete: (taskId) {
                                taskService.toggleTaskCompletion(taskId);
                              },
                              onDelete: (taskId) {
                                taskService.deleteTask(taskId);
                              },
                              onEdit: (task) {
                                _showTaskForm(task: task, taskService: taskService);
                              },
                            );
                          },
                          scrollDirection: Axis.vertical,
                        ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _showTaskForm(taskService: taskService);
              },
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showTaskForm({Task? task, required TaskService taskService}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return TaskForm(
          task: task,
          onSubmit: ({
            required String title,
            DateTime? dueDate,
            TaskPriority priority,
            TaskCategory category,
            DateTime? reminderTime,
          }) {
            if (task != null) {
              taskService.updateTask(
                task.id,
                title: title,
                dueDate: dueDate,
                priority: priority,
                category: category,
                reminderTime: reminderTime,
              );
            } else {
              taskService.addTask(
                title,
                dueDate: dueDate,
                priority: priority,
                category: category,
                reminderTime: reminderTime,
              );
            }
          },
        );
      },
    );
  }
}

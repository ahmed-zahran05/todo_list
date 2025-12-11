import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/core/colors.dart';
import 'package:todo_list/widgets/task_card.dart';
import 'package:todo_list/services/task_service.dart';

import 'calender_screen.dart';

class TodoScreen extends StatefulWidget {
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _taskController = TextEditingController();

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
                            );
                          },
                          scrollDirection: Axis.vertical,
                        ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _taskController.clear();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        top: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Container(
                        height: 250,
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Add Task",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            TextField(
                              controller: _taskController,
                              decoration: InputDecoration(
                                hintText: "Task title",
                                border: OutlineInputBorder(),
                              ),
                              autofocus: true,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_taskController.text.trim().isNotEmpty) {
                                  taskService.addTask(_taskController.text.trim());
                                  Navigator.pop(context);
                                  _taskController.clear();
                                }
                              },
                              child: Text("Add"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}

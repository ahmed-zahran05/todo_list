import 'package:flutter/material.dart';
import 'package:todo_list/models/task.dart';
import 'package:todo_list/core/colors.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  final Function({
    required String title,
    DateTime? dueDate,
    TaskPriority priority,
    TaskCategory category,
    DateTime? reminderTime,
  }) onSubmit;

  const TaskForm({
    Key? key,
    this.task,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _dueDate;
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory _category = TaskCategory.other;
  DateTime? _reminderTime;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _dueDate = widget.task!.dueDate;
      _priority = widget.task!.priority;
      _category = widget.task!.category;
      _reminderTime = widget.task!.reminderTime;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Container(
        height: widget.task != null ? 550 : 500,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.task != null ? "Edit Task" : "Add Task",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Task title",
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            SizedBox(height: 15),

            Text(
              "Priority",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: TaskPriority.values.length,
                itemBuilder: (context, index) {
                  final priority = TaskPriority.values[index];
                  final isSelected = _priority == priority;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(priority.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _priority = priority;
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: _getPriorityColor(priority),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),

            Text(
              "Category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: TaskCategory.values.length,
                itemBuilder: (context, index) {
                  final category = TaskCategory.values[index];
                  final isSelected = _category == category;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category.displayName),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _category = category;
                        });
                      },
                      backgroundColor: Colors.grey[200],
                      selectedColor: AppColors.appBarColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 15),

            ListTile(
              title: Text("Due Date"),
              subtitle: Text(_dueDate != null 
                ? "${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}"
                : "No due date set"),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
            ),
            SizedBox(height: 10),

            ListTile(
              title: Text("Reminder"),
              subtitle: Text(_reminderTime != null 
                ? "${_reminderTime!.day}/${_reminderTime!.month}/${_reminderTime!.year} ${_reminderTime!.hour}:${_reminderTime!.minute.toString().padLeft(2, '0')}"
                : "No reminder set"),
              trailing: Icon(Icons.alarm),
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _reminderTime ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  final TimeOfDay? timePicked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_reminderTime ?? DateTime.now()),
                  );
                  if (timePicked != null) {
                    setState(() {
                      _reminderTime = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        timePicked.hour,
                        timePicked.minute,
                      );
                    });
                  }
                }
              },
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                if (_titleController.text.trim().isNotEmpty) {
                  widget.onSubmit(
                    title: _titleController.text.trim(),
                    dueDate: _dueDate,
                    priority: _priority,
                    category: _category,
                    reminderTime: _reminderTime,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(widget.task != null ? "Update" : "Add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appBarColor,
                foregroundColor: Colors.white,
              ),
            ),
          ],
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

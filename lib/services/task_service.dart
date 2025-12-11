import 'package:flutter/foundation.dart';
import '../models/task.dart';

class TaskService extends ChangeNotifier {
  List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();

  List<Task> get tasks {
    return _tasks.where((task) {
      if (task.dueDate == null) return true;
      return task.dueDate!.day == _selectedDate.day &&
             task.dueDate!.month == _selectedDate.month &&
             task.dueDate!.year == _selectedDate.year;
    }).toList();
  }

  DateTime get selectedDate => _selectedDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addTask(String title, {DateTime? dueDate}) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      dueDate: dueDate ?? _selectedDate,
    );
    _tasks.add(task);
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        isCompleted: !_tasks[taskIndex].isCompleted,
      );
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void updateTask(String taskId, {String? title, DateTime? dueDate}) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        title: title,
        dueDate: dueDate,
      );
      notifyListeners();
    }
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.day == date.day &&
             task.dueDate!.month == date.month &&
             task.dueDate!.year == date.year;
    }).toList();
  }

  int getTaskCountForDate(DateTime date) {
    return getTasksForDate(date).length;
  }
}

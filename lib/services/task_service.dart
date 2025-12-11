import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'notification_service.dart';

enum TaskSortOption {
  date('Date'),
  priority('Priority'),
  category('Category');

  const TaskSortOption(this.displayName);
  final String displayName;
}

class TaskService extends ChangeNotifier {
  List<Task> _tasks = [];
  DateTime _selectedDate = DateTime.now();
  TaskCategory? _filterCategory;
  TaskPriority? _filterPriority;
  TaskSortOption _sortOption = TaskSortOption.date;
  final NotificationService _notificationService = NotificationService();

  List<Task> get tasks {
  var filteredTasks = _tasks.where((task) {
    if (task.dueDate == null) return false;
    bool matchesDate = task.dueDate!.day == _selectedDate.day &&
                       task.dueDate!.month == _selectedDate.month &&
                       task.dueDate!.year == _selectedDate.year;
    
    bool matchesCategory = _filterCategory == null || task.category == _filterCategory;
    bool matchesPriority = _filterPriority == null || task.priority == _filterPriority;
    
    return matchesDate && matchesCategory && matchesPriority;
  }).toList();

  switch (_sortOption) {
    case TaskSortOption.priority:
      filteredTasks.sort((a, b) => b.priority.value.compareTo(a.priority.value));
      break;
    case TaskSortOption.category:
      filteredTasks.sort((a, b) => a.category.name.compareTo(b.category.name));
      break;
    case TaskSortOption.date:
    default:
      filteredTasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
  }

  return filteredTasks;
}

  DateTime get selectedDate => _selectedDate;
  TaskCategory? get filterCategory => _filterCategory;
  TaskPriority? get filterPriority => _filterPriority;
  TaskSortOption get sortOption => _sortOption;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setFilterCategory(TaskCategory? category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterPriority(TaskPriority? priority) {
    _filterPriority = priority;
    notifyListeners();
  }

  void setSortOption(TaskSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  void clearFilters() {
    _filterCategory = null;
    _filterPriority = null;
    notifyListeners();
  }

  void addTask(
    String title, {
    DateTime? dueDate,
    TaskPriority priority = TaskPriority.medium,
    TaskCategory category = TaskCategory.other,
    DateTime? reminderTime,
  }) {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      createdAt: DateTime.now(),
      dueDate: dueDate ?? _selectedDate,
      priority: priority,
      category: category,
      reminderTime: reminderTime,
    );
    _tasks.add(task);
    
    if (reminderTime != null && reminderTime.isAfter(DateTime.now())) {
      _notificationService.scheduleTaskReminder(
        taskId: task.id,
        title: title,
        reminderTime: reminderTime,
        priority: priority,
      );
    }
    
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
    final task = _tasks.firstWhere((task) => task.id == taskId, orElse: () => null);
    if (task != null) {
      _notificationService.cancelTaskReminder(taskId);
    }
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }

  void updateTask(
    String taskId, {
    String? title,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? reminderTime,
  }) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final oldTask = _tasks[taskIndex];
      
      _notificationService.cancelTaskReminder(taskId);
      
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        title: title,
        dueDate: dueDate,
        priority: priority,
        category: category,
        reminderTime: reminderTime,
      );
      
      final newTask = _tasks[taskIndex];
      if (newTask.reminderTime != null && newTask.reminderTime!.isAfter(DateTime.now())) {
        _notificationService.scheduleTaskReminder(
          taskId: newTask.id,
          title: newTask.title,
          reminderTime: newTask.reminderTime!,
          priority: newTask.priority,
        );
      }
      
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

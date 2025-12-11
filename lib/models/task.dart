enum TaskPriority {
  low('Low', 1),
  medium('Medium', 2),
  high('High', 3);

  const TaskPriority(this.displayName, this.value);
  final String displayName;
  final int value;
}

enum TaskCategory {
  work('Work'),
  personal('Personal'),
  shopping('Shopping'),
  health('Health'),
  education('Education'),
  other('Other');

  const TaskCategory(this.displayName);
  final String displayName;
}

class Task {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final DateTime? reminderTime;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.other,
    this.reminderTime,
  });

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    DateTime? reminderTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'category': category.name,
      'reminderTime': reminderTime?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      priority: TaskPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => TaskPriority.medium,
      ),
      category: TaskCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => TaskCategory.other,
      ),
      reminderTime: json['reminderTime'] != null ? DateTime.parse(json['reminderTime']) : null,
    );
  }
}

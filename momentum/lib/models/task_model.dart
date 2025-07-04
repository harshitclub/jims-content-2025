enum TaskPriority { low, medium, high }

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskPriority priority;
  final DateTime createdAt;
  final String location;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.priority = TaskPriority.low,
    required this.createdAt,
    required this.location,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      priority: TaskPriority.values[map['priority']],
      createdAt: DateTime.parse(map['createdAt']),
      location: map['location'],
      isCompleted: map['isCompleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority.index,
      'createdAt': createdAt.toIso8601String(),
      'location': location,
      'isCompleted': isCompleted,
    };
  }
}

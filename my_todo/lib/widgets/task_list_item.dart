import 'package:flutter/material.dart';
import 'package:my_todo/models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?> onToggleCompletion;
  final VoidCallback onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggleCompletion,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onToggleCompletion,
          activeColor: Colors.teal,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontSize: 18.0,
            decoration: task.isCompleted
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline, color: Colors.red),
        ),
        onTap: () => onToggleCompletion(!task.isCompleted),
      ),
    );
  }
}

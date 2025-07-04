// lib/utils/storage_helper.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';

class StorageHelper {
  static const String _taskKey = 'momentum_tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskList = tasks
        .map((task) => jsonEncode(task.toMap()))
        .toList();
    await prefs.setStringList(_taskKey, taskList);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? taskList = prefs.getStringList(_taskKey);
    if (taskList == null) return [];
    return taskList
        .map((taskStr) => Task.fromMap(jsonDecode(taskStr)))
        .toList();
  }
}

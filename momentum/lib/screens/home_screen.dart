import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/storage_helper.dart';
import '../widgets/task_tile.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  TaskPriority? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loaded = await StorageHelper.loadTasks();
    setState(() => _tasks = loaded);
  }

  Future<void> _updateStorage() async {
    await StorageHelper.saveTasks(_tasks);
  }

  void _toggleComplete(String id) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == id);
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    _updateStorage();
  }

  void _deleteTask(String id) {
    setState(() => _tasks.removeWhere((task) => task.id == id));
    _updateStorage();
  }

  Future<void> _navigateToAdd() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (newTask != null) {
      setState(() => _tasks.add(newTask));
      _updateStorage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final visibleTasks = _selectedFilter == null
        ? _tasks
        : _tasks.where((t) => t.priority == _selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Momentum'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.all(mq.width * 0.04),
        child: Column(
          children: [
            DropdownButtonFormField<TaskPriority?>(
              value: _selectedFilter,
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text("All Priorities"),
                ),
                ...TaskPriority.values.map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                  ),
                ),
              ],
              onChanged: (val) {
                setState(() => _selectedFilter = val);
              },
              decoration: InputDecoration(
                labelText: "Filter by Priority",
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: mq.width * 0.04,
                  vertical: mq.height * 0.015,
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.015),
            Expanded(
              child: visibleTasks.isEmpty
                  ? Center(
                      child: Text(
                        "No tasks found.\nTap + to add one!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: mq.width * 0.04),
                      ),
                    )
                  : ListView.builder(
                      itemCount: visibleTasks.length,
                      itemBuilder: (_, i) => TaskTile(
                        task: visibleTasks[i],
                        onToggle: () => _toggleComplete(visibleTasks[i].id),
                        onDelete: () => _deleteTask(visibleTasks[i].id),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: const Icon(Icons.add),
      ),
    );
  }
}

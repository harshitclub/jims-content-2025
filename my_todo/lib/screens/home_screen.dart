import 'package:flutter/material.dart';
import 'package:my_todo/models/task.dart';
import 'package:my_todo/screens/add_task_screen.dart';
import 'package:my_todo/widgets/task_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Our mutable state: the list of tasks
  final List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _tasks.add(Task(title: "Learn Flutter Widgets"));
    _tasks.add(Task(title: "Build To-Do App", isCompleted: true));
    _tasks.add(Task(title: 'Go for a walk'));
  }

  void _addTask(String taskTitle) {
    setState(() {
      _tasks.add(Task(title: taskTitle));
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Task: $taskTitle added!")));
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _tasks[index].isCompleted ? 'Task Completed' : 'Task uncompleted',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _deleteTask(int index) {
    final Task deletedTask = _tasks[index];

    setState(() {
      _tasks.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Task: $deletedTask | Deleted"),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              _tasks.insert(index, deletedTask);
            });
          },
        ),
      ),
    );
  }

  // Navigates to AddTaskScreen and await a result
  Future<void> _navigateAndAddTask() async {
    final String? newTaskTitle = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskScreen()),
    );

    // If a title was returned and it's not empty, add the task
    if (newTaskTitle != null && newTaskTitle.trim().isNotEmpty) {
      _addTask(newTaskTitle.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My To-Do List'), centerTitle: true),

      body: _tasks.isEmpty
          ? Center(
              child: Text(
                'No tasks yet! Add one using the + button.',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

                return Dismissible(
                  key: ValueKey(task.title + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteTask(index);
                  },
                  child: TaskListItem(
                    task: task,
                    onToggleCompletion: (newValue) {
                      _toggleTaskCompletion(index);
                    },
                    onDelete: () => _deleteTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndAddTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}

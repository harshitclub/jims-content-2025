// lib/screens/add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.low;
  String? _currentLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() => _isLoading = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = "Location disabled";
        _isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = "Permission denied";
          _isLoading = false;
        });
        return;
      }
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation =
          "${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}";
      _isLoading = false;
    });
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty || _currentLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter title and allow location")),
      );
      return;
    }

    final task = Task(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      priority: _selectedPriority,
      createdAt: DateTime.now(),
      location: _currentLocation!,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("Add Task"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.05,
          vertical: mq.height * 0.02,
        ),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Task Title"),
            ),
            SizedBox(height: mq.height * 0.015),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description (Optional)",
              ),
              maxLines: 2,
            ),
            SizedBox(height: mq.height * 0.025),
            DropdownButtonFormField<TaskPriority>(
              value: _selectedPriority,
              items: TaskPriority.values.map((p) {
                return DropdownMenuItem(
                  value: p,
                  child: Text(p.name[0].toUpperCase() + p.name.substring(1)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedPriority = val);
              },
              decoration: const InputDecoration(labelText: "Priority"),
            ),
            SizedBox(height: mq.height * 0.025),
            _isLoading
                ? const CircularProgressIndicator()
                : Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _currentLocation ?? "Fetching location...",
                          style: TextStyle(fontSize: mq.width * 0.035),
                        ),
                      ),
                    ],
                  ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text("Save Task"),
                onPressed: _saveTask,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

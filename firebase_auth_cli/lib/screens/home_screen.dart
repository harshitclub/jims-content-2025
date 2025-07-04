// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/snackbar_helper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        SnackBarHelper.showSnackBar(
          context,
          'Logged out successfully!',
          Colors.green,
        );
        // StreamBuilder in main.dart will automatically navigate to LoginScreen
      }
    } catch (e) {
      if (context.mounted) {
        SnackBarHelper.showSnackBar(
          context,
          'Error logging out: $e',
          Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String? userEmail = user?.email;
    final String? userId = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.waving_hand, size: 100, color: Colors.indigo),
                const SizedBox(height: 30),
                const Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                const SizedBox(height: 20),
                if (userEmail != null)
                  Text(
                    'You are logged in as:',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
                  ),
                if (userEmail != null)
                  Text(
                    userEmail,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigoAccent,
                    ),
                  ),
                const SizedBox(height: 10),
                if (userId != null)
                  Text(
                    'Your User ID:',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                if (userId != null)
                  SelectableText(
                    // Allows user to copy the ID
                    userId,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'monospace',
                      color: Colors.black54,
                    ),
                  ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Button color
                    foregroundColor: Colors.white, // Text/icon color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

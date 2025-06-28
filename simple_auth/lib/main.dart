// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp is a StatelessWidget because its content (the MaterialApp) doesn't change.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login/Signup Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue, // A nice blue theme for the app
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // Adapts UI density for different platforms
      ),
      home: const AuthScreen(), // Our main screen, which is Stateful
    );
  }
}

// AuthScreen is a StatefulWidget because it needs to manage
// whether to show the Login form or the Signup form,
// and the input values within those forms.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

// The State class associated with AuthScreen.
class _AuthScreenState extends State<AuthScreen> {
  // --- State Variables for AuthScreen ---
  bool _showLogin = true; // Controls which form is currently visible

  // --- Controllers for Login Form Inputs ---
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  // --- Controllers for Signup Form Inputs ---
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();
  final TextEditingController _signupConfirmPasswordController =
      TextEditingController();

  // --- Lifecycle Method: dispose ---
  // It's crucial to dispose of TextEditingControllers when the widget is removed
  // from the widget tree to prevent memory leaks.
  @override
  void dispose() {
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _signupEmailController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();
    super.dispose();
  }

  // --- Methods to Handle Form Submissions ---

  // Called when the Login button is pressed
  void _handleLogin() {
    // Get the current text from the controllers
    final String email = _loginEmailController.text;
    final String password = _loginPasswordController.text;

    // Print the data to the terminal (console)
    print('--- Login Attempt ---');
    print('Email: $email');
    print('Password: $password');
    print('---------------------');

    // In a real app, you would send this data to your backend for authentication.
    // For this basic example, we're just printing.
  }

  // Called when the Signup button is pressed
  void _handleSignup() {
    // Get the current text from the controllers
    final String email = _signupEmailController.text;
    final String password = _signupPasswordController.text;
    final String confirmPassword = _signupConfirmPasswordController.text;

    // Print the data to the terminal (console)
    print('--- Signup Attempt ---');
    print('Email: $email');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
    if (password != confirmPassword) {
      print('Error: Passwords do not match!');
    }
    print('----------------------');

    // In a real app, you would send this data to your backend for user registration.
    // For this basic example, we're just printing.
  }

  // --- Build Method: Describes the UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showLogin ? 'Login Page' : 'Signup Page',
        ), // App bar title changes dynamically
      ),
      body: Center(
        child: SingleChildScrollView(
          // Allows content to scroll if it exceeds screen height
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // --- Display either Login or Signup Form ---
              _showLogin ? _buildLoginForm() : _buildSignupForm(),
              const SizedBox(height: 20), // Spacer
              // --- Toggle Button between Login and Signup ---
              TextButton(
                onPressed: () {
                  // setState is called to trigger a rebuild of the widget,
                  // which will switch between showing the login or signup form.
                  setState(() {
                    _showLogin = !_showLogin; // Toggle the boolean value
                    // Clear controllers when switching forms for a cleaner experience
                    _loginEmailController.clear();
                    _loginPasswordController.clear();
                    _signupEmailController.clear();
                    _signupPasswordController.clear();
                    _signupConfirmPasswordController.clear();
                  });
                },
                child: Text(
                  _showLogin
                      ? 'Don\'t have an account? Sign Up'
                      : 'Already have an account? Login',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Method to Build Login Form ---
  Widget _buildLoginForm() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _loginEmailController, // Link controller to TextField
          keyboardType:
              TextInputType.emailAddress, // Optimize keyboard for email
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15), // Spacer
        TextField(
          controller: _loginPasswordController, // Link controller to TextField
          obscureText: true, // Hide text for password
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20), // Spacer
        ElevatedButton(
          onPressed: _handleLogin, // Call the login handler
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Login'),
        ),
      ],
    );
  }

  // --- Helper Method to Build Signup Form ---
  Widget _buildSignupForm() {
    return Column(
      children: <Widget>[
        TextField(
          controller: _signupEmailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _signupPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            hintText: 'Create a password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: _signupConfirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _handleSignup, // Call the signup handler
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}

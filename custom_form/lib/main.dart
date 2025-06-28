// main.dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Form Page',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SimpleFullFormPage(),
    );
  }
}

// SimpleFullFormPage: This is a 'Stateful' widget. Why?
// Because the information the user types or selects (like their name,
// whether a checkbox is checked, which option is chosen from a list)
// will CHANGE over time, and we need our app's screen to update
// to show those changes.
class SimpleFullFormPage extends StatefulWidget {
  const SimpleFullFormPage({super.key});

  @override
  // This function creates the 'State' object for our widget.
  // Think of the 'State' object as the actual manager that holds all
  // the changing data for this page.
  State<SimpleFullFormPage> createState() => _SimpleFullFormPageState();
}

// _SimpleFullFormPageState: This is the 'manager' (the State object)
// for our SimpleFullFormPage. All the data that changes on the form
// will be stored here.
class _SimpleFullFormPageState extends State<SimpleFullFormPage> {
  // --- 1. Variables to hold data from our form fields ---

  // For text inputs (like name, email, password, bio), we use TextEditingController.
  // It's like a special pen that writes and reads text from the input box.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController =
      TextEditingController(); // For longer text

  // For a dropdown (like Gender), we need a variable to store the selected text.
  // 'String?' means it can hold a String or be empty (null).
  String? _selectedGender;

  // For a checkbox (Accept Terms), we need a 'true' or 'false' variable.
  bool _acceptTerms = false;

  // For radio buttons (Payment Method), we need a variable to store the selected option.
  String? _selectedPaymentMethod;

  // For a slider (Rating), we need a number variable (double means it can have decimals).
  double _rating = 5.0; // Start at 5.0

  // For a switch (Notifications), we need a 'true' or 'false' variable.
  bool _receiveNotifications = true; // Start as true (on)

  // For date and time pickers, we need variables to store the selected date and time.
  DateTime? _selectedDate; // Can be a date or empty (null)
  TimeOfDay? _selectedTime; // Can be a time or empty (null)

  // --- 2. Cleanup (Very Important!) ---
  // This 'dispose' function is called when our form page is removed from the screen.
  // It's essential to 'dispose' of our TextEditingControllers to prevent
  // memory problems (like leaving pens writing even after you throw away the paper!).
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    super.dispose(); // Always call this last
  }

  // --- 3. Functions to show Date and Time Pickers ---

  // Function to open the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context, // Where to show the picker
      initialDate:
          _selectedDate ??
          DateTime.now(), // Start date (today if nothing selected)
      firstDate: DateTime(2000), // Earliest year you can pick
      lastDate: DateTime(2101), // Latest year you can pick
    );
    // If the user picked a date AND it's different from what we had before:
    if (pickedDate != null && pickedDate != _selectedDate) {
      // This is the MAGIC line for Stateful Widgets!
      // 'setState' tells Flutter: "Hey, some data changed! Please re-draw my screen!"
      setState(() {
        _selectedDate = pickedDate; // Update our date variable
      });
    }
  }

  // Function to open the time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context, // Where to show the picker
      initialTime:
          _selectedTime ??
          TimeOfDay.now(), // Start time (now if nothing selected)
    );
    // If the user picked a time AND it's different from what we had before:
    if (pickedTime != null && pickedTime != _selectedTime) {
      // Again, 'setState' is called to update the screen.
      setState(() {
        _selectedTime = pickedTime; // Update our time variable
      });
    }
  }

  // --- 4. Function to handle when the "Submit" button is pressed ---
  void _submitFormData() {
    // We just print all the data we've collected from the form fields.
    // In a real app, you would send this data to a server or save it somewhere.
    print('--- Form Data Collected ---');
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print(
      'Password: ${_passwordController.text}',
    ); // (In a real app, send securely!)
    print('Bio: ${_bioController.text}');
    print(
      'Gender: ${_selectedGender ?? "Not chosen"}',
    ); // Show "Not chosen" if nothing selected
    print('Accept Terms: $_acceptTerms');
    print('Payment Method: ${_selectedPaymentMethod ?? "Not chosen"}');
    print('Rating: $_rating.round()'); // .round() makes it a whole number
    print('Receive Notifications: $_receiveNotifications');
    // Format date and time nicely for printing
    print(
      'Selected Date: ${_selectedDate?.toLocal().toString().split(' ')[0] ?? "Not chosen"}',
    );
    print('Selected Time: ${_selectedTime?.format(context) ?? "Not chosen"}');
    print('--------------------------');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form data printed to console!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Multi-Field Form')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- TEXT FIELD: Full Name ---
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 20),
            // --- TEXT FIELD: Email Address ---
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'your@email.com',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // --- TEXT FIELD: Password ---
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Min. 6 characters',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 20),

            // --- TEXT FIELD: Bio (Multi-line) ---
            TextField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Your Bio (Optional)',
                hintText: 'Tell us a little about yourself...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),

            // --- DROPDOWN BUTTON: Gender ---
            // Allows selecting one option from a list.
            DropdownButtonFormField<String>(
              value: _selectedGender,
              hint: const Text(
                'Select Gender',
              ), // Text shown when nothing is selected
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items:
                  const <String>[
                    'Male',
                    'Female',
                    'Non-binary',
                    'Prefer not to say',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                // When a new option is picked, 'newValue' will be that option.
                // We use setState to tell Flutter to update the screen
                // with the new chosen value.
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // --- CHECKBOX: Accept Terms ---
            CheckboxListTile(
              title: const Text(
                'I accept the terms and conditions',
              ), // Text next to checkbox
              value:
                  _acceptTerms, // Current state of the checkbox (checked or not)
              onChanged: (bool? newValue) {
                // When tapped, 'newValue' is the new state (true or false).
                // setState updates the variable and re-draws the checkbox.
                setState(() {
                  _acceptTerms =
                      newValue!; // The '!' means we know it won't be null here
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 20),

            // --- RADIO BUTTONS: Payment Method ---
            const Text(
              'Preferred Payment Method:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              title: const Text('Credit Card'),
              value: 'Credit Card', // The unique value for this radio button
              groupValue:
                  _selectedPaymentMethod, // The currently selected value for the whole group
              onChanged: (String? newValue) {
                // When this radio button is tapped, update the group's selected value.
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('PayPal'),
              value: 'PayPal',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Bank Transfer'),
              value: 'Bank Transfer',
              groupValue: _selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPaymentMethod = newValue;
                });
              },
            ),
            const SizedBox(height: 20),

            // --- SLIDER: Rating ---
            // Used to select a value from a continuous range (like 0 to 10).
            const Text(
              'Rating:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _rating, // Current value of the slider
              min: 0, // Minimum value the slider can go to
              max: 10, // Maximum value the slider can go to
              divisions: 10,
              label: _rating
                  .round()
                  .toString(), // Text shown above the slider thumb when dragging
              onChanged: (double newValue) {
                // As you drag the slider, this changes. setState updates the screen.
                setState(() {
                  _rating = newValue;
                });
              },
            ),
            Text(
              'Current Rating: ${_rating.round()}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),

            // --- SWITCH: Receive Notifications ---
            // A simple ON/OFF toggle.
            SwitchListTile(
              title: const Text('Receive Marketing Notifications'),
              value:
                  _receiveNotifications, // Current state (true for ON, false for OFF)
              onChanged: (bool newValue) {
                // When you tap the switch, setState updates its state and appearance.
                setState(() {
                  _receiveNotifications = newValue;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 20),

            // --- DATE PICKER (triggered by tapping a ListTile) ---
            // A button-like area that opens a calendar to pick a date.
            ListTile(
              title: const Text('Select Your Birthday'),
              subtitle: Text(
                _selectedDate == null
                    ? 'No date selected' // Shown if no date has been picked yet
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}', // Shows picked date
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              trailing: const Icon(
                Icons.calendar_today,
              ), // Calendar icon on the right
              onTap: () => _selectDate(
                context,
              ), // When tapped, call our date picker function
            ),
            const SizedBox(height: 20),

            // --- TIME PICKER (triggered by tapping a ListTile) ---
            // A button-like area that opens a clock to pick a time.
            ListTile(
              title: const Text('Select Preferred Time'),
              subtitle: Text(
                _selectedTime == null
                    ? 'No time selected' // Shown if no time has been picked yet
                    : _selectedTime!.format(
                        context,
                      ), // Shows picked time in readable format
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              trailing: const Icon(
                Icons.access_time,
              ), // Clock icon on the right
              onTap: () => _selectTime(
                context,
              ), // When tapped, call our time picker function
            ),
            const SizedBox(height: 30),

            // --- SUBMIT BUTTON ---
            // When this button is pressed, we'll print all the collected data.
            Center(
              child: ElevatedButton(
                onPressed:
                    _submitFormData, // Call our function to print all data
                child: const Text('Submit All Form Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

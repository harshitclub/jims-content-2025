import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Form Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SimpleFormPage(),
    );
  }
}

class SimpleFormPage extends StatefulWidget {
  const SimpleFormPage({super.key});
  @override
  _SimpleFormPageState createState() => _SimpleFormPageState();
}

class _SimpleFormPageState extends State<SimpleFormPage> {
  // GlobalKey to uniquely identify the Form and allow validation/saving.
  // This is crucial for interacting with the Form widget.
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();

  String? _selectedCity;

  bool _agreedToTerms = false;

  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree.
    // This frees up resources and prevents memory leaks.
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Form'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // --- Name Input (TextFormField) ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'e.g., John Doe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  print('Name saved: ${value ?? "N/A"}');
                },
              ),
              const SizedBox(height: 20),
              // --- City Dropdown (DropdownButtonFormField) ---
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Your City',
                  hintText: 'Choose a city',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  prefixIcon: Icon(Icons.location_city),
                ),
                value: _selectedCity,
                items: <String>['New York', 'London', 'Paris', 'Tokyo', 'Noida']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your city';
                  }
                  return null;
                },
                onSaved: (value) {
                  print('City saved: ${value ?? "N/A"}');
                },
              ),
              const SizedBox(height: 20),

              // --- Terms Agreement (CheckboxListTile) ---
              CheckboxListTile(
                title: const Text('I agree to the terms and conditions'),
                value: _agreedToTerms,
                onChanged: (bool? newValue) {
                  setState(() {
                    _agreedToTerms = newValue ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blueAccent,
              ),
              const SizedBox(height: 30),

              // --- Submit Button ---
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    print('\n--- Form Data ---');
                    print('Name: ${_nameController.text}');
                    print(
                      'Selected City: ${_selectedCity ?? "No City Selected"}',
                    );
                    print('Agreed to Terms: $_agreedToTerms');
                    print('-----------------\n');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Form Submitted Successfully! Check Terminal for Data.',
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // If the form is not valid, show an error message.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please correct the errors in the form.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  shadowColor: Colors.blueAccent,
                ),
                child: const Text(
                  'Submit Form',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

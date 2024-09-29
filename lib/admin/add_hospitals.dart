import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medapp/admin/admin_nav.dart';

import '../profilepage/userprofile.dart';

class AddHospitals extends StatefulWidget {
  const AddHospitals({Key? key}) : super(key: key);

  @override
  State<AddHospitals> createState() => _AddHospitalsState();
}

class _AddHospitalsState extends State<AddHospitals> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  // Controller for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _timingsController = TextEditingController();
  final TextEditingController _hospitalId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        title: const Text("Add Hospitals", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
    child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _hospitalId,
                    decoration: const InputDecoration(
                      labelText: 'HospitalId',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please ensure to enter a unique HospId';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Hospital Name',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the hospital name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _typeController,
                    decoration: const InputDecoration(
                      labelText: 'Contact',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _timingsController,
                    decoration: const InputDecoration(
                      labelText: 'Timings',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the timings';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Add logic to save hospital details
                        _saveHospitalDetails();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Add Hospital', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
      drawer: const AdminNav(),
    );
  }

  // Add a function to save hospital details
  void _saveHospitalDetails() async {
    try {
      // Get values from text controllers
      String name = _nameController.text;
      String location = _locationController.text;
      String contact = _typeController.text;
      String timings = _timingsController.text;
      String hospitalId = _hospitalId.text;

      // Add hospital details to Firestore with hospitalId as a field within the document
      await FirebaseFirestore.instance
          .collection('hospitals')
          .doc(hospitalId)
          .set({
        'name': name,
        'location': location,
        'contact': contact,
        'timings': timings,
        'hospitalId': hospitalId
      });

      // Show success message or navigate to the next screen
      _showSuccessMessage();
      _nameController.clear();
      _locationController.clear();
      _typeController.clear();
      _timingsController.clear();
      _hospitalId.clear();

    } catch (e) {
      print('Error saving hospital details: $e');
      // Show error message or handle the error as needed
    }
  }

  // Function to show a success message
  void _showSuccessMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Success',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Hospital details saved successfully.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
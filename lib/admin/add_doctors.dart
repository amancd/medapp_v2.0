import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../profilepage/userprofile.dart';
import 'admin_nav.dart';

class AddDoctorsPage extends StatefulWidget {
  const AddDoctorsPage({Key? key}) : super(key: key);

  @override
  _AddDoctorsPageState createState() => _AddDoctorsPageState();
}

class Doctor {
  final String name;
  final String specialty;

  Doctor({required this.name, required this.specialty});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specialty': specialty,
    };
  }
}

class _AddDoctorsPageState extends State<AddDoctorsPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hospitalIdController = TextEditingController();
  final List<Doctor> _doctorsList = [];
  int _numberOfDoctors = 1;

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
        title: const Text("Add Doctors", style: TextStyle(color: Colors.white)),
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
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _hospitalIdController,
                decoration: const InputDecoration(labelText: 'Hospital ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the hospital ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Number of Doctors: '),
                  DropdownButton<int>(
                    value: _numberOfDoctors,
                    items: List.generate(10, (index) {
                      return DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text((index + 1).toString()),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        _numberOfDoctors = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Generate TextFormFields based on the number of doctors
              for (int i = 0; i < _numberOfDoctors; i++)
                Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Doctor ${i + 1} Name'),
                      onSaved: (value) {
                        _doctorsList.add(Doctor(name: value!, specialty: ''));
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the doctor name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Specialty ${i + 1}'),
                      onSaved: (value) {
                        _doctorsList[i] = Doctor(name: _doctorsList[i].name, specialty: value!);
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the doctor specialty';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveDoctors();
                  }
                },
                child: const Text('Save Doctors'),
              ),
            ],
          ),
        ),
      ),
      ),
      drawer: const AdminNav(),
    );
  }

  void _saveDoctors() async {
    // Save doctors and specialties to Firestore
    for (var doctor in _doctorsList) {
      await FirebaseFirestore.instance
          .collection('hospitals')
          .doc(_hospitalIdController.text)
          .collection('doctors')
          .add(doctor.toMap());
    }

    // Show success message or navigate to the next screen
    _showSuccessMessage();
    _hospitalIdController.clear();
    print('Before clearing: $_doctorsList');
    _doctorsList.clear();
    print('After clearing: $_doctorsList');
  }

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
                const Text('Doctor added successfully!.'),
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
                  child: const Text(
                      'OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

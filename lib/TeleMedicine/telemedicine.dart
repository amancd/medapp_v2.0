import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../Navigation/menu.dart';
import '../provider/auth_provider.dart';
import '../screens/home_screen.dart';

class TeleMedicine extends StatefulWidget {
  const TeleMedicine({Key? key}) : super(key: key);

  @override
  State<TeleMedicine> createState() => _TeleMedicineState();
}

class _TeleMedicineState extends State<TeleMedicine> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.Reference storageReference =
  firebase_storage.FirebaseStorage.instance.ref();

  // Variables to store form data
  String selectedState = "State 1";
  String selectedCity = "City 1";
  String selectedMedicine = "Medicine 1";
  String selectedPharmacy = "Pharmacy 1";
  String address = "";
  String? fileURL;

  // Dummy data for states, cities, medicines, and pharmacies
  List<String> states = ["State 1", "State 2", "State 3"];
  Map<String, List<String>> citiesByState = {
    "State 1": [
      "City 1",
      "City 2",
      "City 3",
      "Village 1",
      "Village 2",
      "Village 3"
    ],
    "State 2": [
      "City 4",
      "City 5",
      "City 6",
      "Village 4",
      "Village 5",
      "Village 6"
    ],
    "State 3": [
      "City 7",
      "City 8",
      "City 9",
      "Village 7",
      "Village 8",
      "Village 9"
    ],
  };
  List<String> medicines = [
    "Medicine 1",
    "Medicine 2",
    "Medicine 3",
    "Medicine 4",
    "Medicine 5"
  ];
  Map<String, List<String>> pharmaciesByCity = {
    "City 1": ["Pharmacy 1", "Pharmacy 2", "Pharmacy 3"],
    "City 2": ["Pharmacy 4", "Pharmacy 5", "Pharmacy 6"],
    "City 3": ["Pharmacy 7", "Pharmacy 8", "Pharmacy 9"],
    "City 4": ["Pharmacy 1", "Pharmacy 2", "Pharmacy 3"],
    "City 5": ["Pharmacy 4", "Pharmacy 5", "Pharmacy 6"],
    "City 6": ["Pharmacy 7", "Pharmacy 8", "Pharmacy 9"],
    "City 7": ["Pharmacy 1", "Pharmacy 2", "Pharmacy 3"],
    "City 8": ["Pharmacy 4", "Pharmacy 5", "Pharmacy 6"],
    "City 9": ["Pharmacy 7", "Pharmacy 8", "Pharmacy 9"],
    "Village 1": ["Pharmacy 1", "Pharmacy 2", "Pharmacy 3"],
    "Village 2": ["Pharmacy 4", "Pharmacy 5", "Pharmacy 6"],
    "Village 3": ["Pharmacy 7", "Pharmacy 8", "Pharmacy 9"],
    "Village 4": ["Pharmacy 1", "Pharmacy 2", "Pharmacy 3"],
    "Village 5": ["Pharmacy 4", "Pharmacy 5", "Pharmacy 6"],
    "Village 6": ["Pharmacy 7", "Pharmacy 8", "Pharmacy 9"],
    "Village 7": ["Pharmacy 1", "Pharmacy 2", "Pharmacy 3"],
    "Village 8": ["Pharmacy 4", "Pharmacy 5", "Pharmacy 6"],
    "Village 9": ["Pharmacy 7", "Pharmacy 8", "Pharmacy 9"],
  };

  Map<String, String> pharmacyIds = {
    "Pharmacy 1": "pharma1",
    "Pharmacy 2": "pharma2",
    "Pharmacy 3": "pharma3",
    "Pharmacy 4": "pharma4",
    "Pharmacy 5": "pharma5",
    "Pharmacy 6": "pharma6",
    "Pharmacy 7": "pharma7",
    "Pharmacy 8": "pharma8",
    "Pharmacy 9": "pharma9",

  };

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text(
          "TeleMedicine",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: buildForm(ap),
      drawer: const Navigation(),
    );
  }

  Widget buildForm(AuthProvider authProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 18.0),
          DropdownButtonFormField<String>(
            value: selectedState,
            items: states.map((state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Select State',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                selectedState = value!;
                // Reset selected city, medicine, and pharmacy when state changes
                selectedCity = citiesByState[selectedState]![0];
                selectedMedicine = medicines[0];
                selectedPharmacy = pharmaciesByCity[selectedCity]![0];
              });
            },
          ),
          const SizedBox(height: 18.0),
          if (selectedState.isNotEmpty)
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: citiesByState[selectedState]!.map((city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Select City',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                  // Reset selected medicine and pharmacy when city changes
                  selectedMedicine = medicines[0];
                  selectedPharmacy = pharmaciesByCity[selectedCity]![0];
                });
              },
            ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: selectedMedicine,
            items: medicines.map((medicine) {
              return DropdownMenuItem<String>(
                value: medicine,
                child: Text(medicine),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Select Medicine',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                selectedMedicine = value!;
              });
            },
          ),
          const SizedBox(height: 16.0),
          DropdownButtonFormField<String>(
            value: selectedPharmacy,
            items: pharmacyIds.keys.map((pharmacy) {
              return DropdownMenuItem<String>(
                value: pharmacy,
                child: Text(pharmacy),
              );
            }).toList(),
            decoration: const InputDecoration(
              labelText: 'Select Pharmacy',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                selectedPharmacy = value!;
              });
            },
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Enter Address',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                address = value;
              });
            },
          ),
          const SizedBox(height: 18.0),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  // Trigger file pick
                  String? result = await pickFile();
                  if (result != null) {
                    setState(() async {
                      String? downloadURL = await uploadFile(result);
                      if (downloadURL != null) {
                        // Set the Firebase Storage URL directly
                        setState(() {
                          fileURL = downloadURL;
                        });
                        // Handle the download URL, you can store it in Firestore or use it as needed
                        print('File uploaded. Download URL: $downloadURL');
                      } else {
                        print('File upload failed.');
                      }
                    });
                  }
                },
              ),
              const Text('Attach Prescription'),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              // Handle form submission
              if (selectedState.isNotEmpty &&
                  selectedCity.isNotEmpty &&
                  selectedMedicine.isNotEmpty &&
                  selectedPharmacy.isNotEmpty &&
                  address.isNotEmpty &&
                  fileURL != null) {

                String selectedPharmacyId = pharmacyIds[selectedPharmacy] ?? '';
                String orderId = const Uuid().v4();

                await _firestore.collection('telemedicine_requests').doc(orderId).set({
                  'state': selectedState,
                  'city': selectedCity,
                  'medicine': selectedMedicine,
                  'pharmacy': selectedPharmacy,
                  'pharmacyId': selectedPharmacyId,
                  'address': address,
                  'fileURL': fileURL,
                  'phoneNumber': authProvider.userModel.phoneNumber,
                  'name': authProvider.userModel.name,
                  'email': authProvider.userModel.email,
                  'bood group': authProvider.userModel.blood,
                  'uid': authProvider.userModel.uid,
                  'status': 'Pending',
                  'orderId': orderId,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Request forwarded to hospitals')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                      Text('Please fill in all fields and attach a file')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              textStyle: const TextStyle(color: Colors.white),
            ),
            child: const Text('Submit Request',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      return result.files.single.path;
    }
    return null;
  }

  Future<String?> uploadFile(String filePath) async {
    try {
      File file = File(filePath);
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref =
      storageReference.child('prescriptions/$fileName.pdf');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../admin/admin_home.dart';
import '../admin/admin_nav.dart';

class ATeleMedicine extends StatefulWidget {
  const ATeleMedicine({Key? key}) : super(key: key);

  @override
  State<ATeleMedicine> createState() => _ATeleMedicineState();
}

class _ATeleMedicineState extends State<ATeleMedicine> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variables to store form data
  String selectedState = "State 1";
  String selectedCity = "City 1";
  String selectedMedicine = "Medicine 1";
  String selectedPharmacy = "Pharmacy 1";
  String address = "";

  // Dummy data for states, cities, medicines, and pharmacies
  List<String> states = ["State 1", "State 2", "State 3"];
  Map<String, List<String>> citiesByState = {
    "State 1": ["City 1", "City 2", "City 3", "Village 1", "Village 2", "Village 3"],
    "State 2": ["City 4", "City 5", "City 6", "Village 4", "Village 5", "Village 6"],
    "State 3": ["City 7", "City 8", "City 9", "Village 7", "Village 8", "Village 9"],
  };
  List<String> medicines = ["Medicine 1", "Medicine 2", "Medicine 3", "Medicine 4", "Medicine 5"];
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
    "Pharmacy 1": "pharmacy_1",
    "Pharmacy 2": "pharmacy_2",
    "Pharmacy 3": "pharmacy_3",
    "Pharmacy 4": "pharmacy_4",
    "Pharmacy 5": "pharmacy_5",
    "Pharmacy 6": "pharmacy_6",
    "Pharmacy 7": "pharmacy_7",
    "Pharmacy 8": "pharmacy_8",
    "Pharmacy 9": "pharmacy_9",
    // Add more pharmacies as needed
  };

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
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("TeleMedicine", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AdminHome()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: buildForm(),
      drawer: const AdminNav(),
    );
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              // Handle form submission
              if (selectedState.isNotEmpty &&
                  selectedCity.isNotEmpty &&
                  selectedMedicine.isNotEmpty &&
                  selectedPharmacy.isNotEmpty &&
                  address.isNotEmpty) {

                String selectedPharmacyId = pharmacyIds[selectedPharmacy] ?? '';

                await _firestore.collection('telemedicine_requests').add({
                  'state': selectedState,
                  'city': selectedCity,
                  'medicine': selectedMedicine,
                  'pharmacy': selectedPharmacy,
                  'pharmacyId': selectedPharmacyId,
                  'address': address,
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Request forwarded to hospitals')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              textStyle: const TextStyle(color: Colors.white),
            ),
            child: const Text('Submit Request', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

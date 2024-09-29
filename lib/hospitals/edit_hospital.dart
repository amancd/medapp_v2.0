import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medapp/hospitals/add_doctors.dart';

import '../admin/add_doctors.dart';
import 'hospital_nav.dart';

class EditHospitals extends StatefulWidget {
  const EditHospitals({Key? key}) : super(key: key);

  @override
  State<EditHospitals> createState() => _EditHospitalsState();
}

class _EditHospitalsState extends State<EditHospitals> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<HospitalModel> _hospitals = [];

  @override
  void initState() {
    super.initState();
    fetchHospitalsData();
  }

  Future<void> fetchHospitalsData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    String hospitalId = email.split('@')[0];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("hospitals")
          .where('hospitalId', isEqualTo: hospitalId)
          .limit(10) // Adjust the limit based on your needs
          .get();

      setState(() {
        _hospitals = querySnapshot.docs.map((doc) {
          return HospitalModel(
            hospitalId: doc['hospitalId'],
            name: doc['name'],
            contact: doc['contact'],
            timings: doc['timings'] ?? '',
            location: doc['location'] ?? '',
            // Add other fields as needed
          );
        }).toList();
      });
    if (mounted) {
      setState(() {}); // Ensure the UI rebuilds after fetching data
    }
  }

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
        title: const Text("Edit Details",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HAddDoctorsPage()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: _hospitals.isEmpty
          ? const Center(
        child: Text("No Hospitals Found"),
      )
          : ListView.builder(
        itemCount: _hospitals.length,
        itemBuilder: (context, index) {
          HospitalModel hospital = _hospitals[index];
          return Column(
            children: [
              Card(
                elevation: 4.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurpleAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(
                              text: "Hospital Name: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: hospital.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Address: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: hospital.location,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Contact: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: hospital.contact,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Timings: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: hospital.timings,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the edit screen with hospital details
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditHospitalDetails(hospital),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent, // Set the button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Edit Details',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      drawer: const HNav(),
    );
  }
}

class EditHospitalDetails extends StatefulWidget {
  final HospitalModel hospital;

  const EditHospitalDetails(this.hospital, {Key? key}) : super(key: key);

  @override
  State<EditHospitalDetails> createState() => _EditHospitalDetailsState();
}

class _EditHospitalDetailsState extends State<EditHospitalDetails> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _timingsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    _nameController.text = widget.hospital.name;
    _contactController.text = widget.hospital.contact;
    _locationController.text = widget.hospital.location;
    _timingsController.text = widget.hospital.timings;
  }

  Future<void> _updateHospitalDetails() async {
    try {
      // Get the updated values from controllers
      String updatedName = _nameController.text;
      String updatedContact = _contactController.text;
      String updatedLocation = _locationController.text;
      String updatedTimings = _timingsController.text;

      // Update the hospital details in Firestore or your data storage
      await FirebaseFirestore.instance
          .collection("hospitals")
          .doc(widget.hospital.hospitalId)
          .update({
        'name': updatedName,
        'contact': updatedContact,
        'location': updatedLocation,
        'timings': updatedTimings,
      });

      // Optionally, you can update the local widget state or perform other actions after a successful update

    } catch (e) {
      // Handle errors if the update fails
      print('Error updating hospital details: $e');
    }
  }

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
        title: const Text("Edit Details",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddDoctorsPage()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Hospital Name'),
            ),
            TextField(
              controller: _contactController,
              decoration: const InputDecoration(labelText: 'Contact'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _timingsController,
              decoration: const InputDecoration(labelText: 'Timings'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _updateHospitalDetails();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EditHospitals()),
                );

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Update Details',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const HNav(),
    );
  }
}



class HospitalModel {
  final String hospitalId;
  final String name;
  final String contact;
  final String timings;
  final String location;

  HospitalModel({
    required this.hospitalId,
    required this.name,
    required this.contact,
    required this.timings,
    required this.location
  });
}

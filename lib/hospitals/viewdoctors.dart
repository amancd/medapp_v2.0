import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medapp/hospitals/hospital_nav.dart';
import 'package:medapp/hospitals/request_admin.dart';

class ViewDoctors extends StatefulWidget {
  const ViewDoctors({Key? key}) : super(key: key);

  @override
  _ViewDoctorsState createState() => _ViewDoctorsState();
}

class _ViewDoctorsState extends State<ViewDoctors> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<DoctorModel> _doctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctorsData();
  }

  Future<void> fetchDoctorsData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    String hospitalId = email.split('@')[0];

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("hospitals")
          .doc(hospitalId)
          .collection("doctors")
          .get();

      setState(() {
        _doctors = querySnapshot.docs.map((doc) {
          return DoctorModel(
            name: doc['name'],
            specialty: doc['specialty'],
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
        title: const Text("All Doctors", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RequestAdmin()),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: _doctors.isEmpty
          ? const Center(
        child: Text("No Doctors Found"),
      )
          : ListView.builder(
        itemCount: _doctors.length,
        itemBuilder: (context, index) {
          DoctorModel doctor = _doctors[index];

          return Card(
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
                title: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                    children: [
                      const TextSpan(
                        text: "Name: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: doctor.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                      children: [
                        const TextSpan(
                          text: "Specialty: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: doctor.specialty,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      drawer: const HNav(),
    );
  }
}

class DoctorModel {
  final String name;
  final String specialty;

  DoctorModel({
    required this.name,
    required this.specialty,
    // Add other fields as needed
  });
}

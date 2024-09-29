import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medapp/screens/home_screen.dart';

import '../Navigation/menu.dart';

class AllHospitals extends StatefulWidget {
  const AllHospitals({Key? key}) : super(key: key);

  @override
  State<AllHospitals> createState() => _AllHospitalsState();
}

class Hospital {
  final String name;
  final String location;
  final String contact;
  final String timings;

  Hospital({
    required this.name,
    required this.location,
    required this.contact,
    required this.timings,
  });
}

Future<List<Hospital>> fetchHospitalData() async {
  QuerySnapshot querySnapshot =
  await FirebaseFirestore.instance.collection('hospitals').get();

  return querySnapshot.docs.map((doc) {
    return Hospital(
      name: doc['name'],
      location: doc['location'],
      contact: doc['contact'],
      timings: doc['timings'],
    );
  }).toList();
}

class _AllHospitalsState extends State<AllHospitals> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<Hospital> hospitals = [];

  @override
  void initState() {
    super.initState();
    fetchHospitalData().then((data) {
      setState(() {
        hospitals = data;
      });
    });
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
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("All Hospitals", style: TextStyle(color: Colors.white)),
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
      body: ListView.builder(
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          return HospitalCard(hospital: hospitals[index]);
        },
      ),
      drawer: const Navigation(),
    );
  }
}

class HospitalCard extends StatelessWidget {
  final Hospital hospital;

  HospitalCard({required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          colors: [Colors.deepOrange, Colors.redAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text(
          '${hospital.name}',
          style: const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Text(
              'Location: ${hospital.location}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Contact: ${hospital.contact}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 4.0),
            Text(
              'Timings: ${hospital.timings}',
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 8.0),
          ],
        ),
        tileColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}



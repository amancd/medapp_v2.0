import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medapp/Pharma/Pharma_home.dart';
import 'package:medapp/pharma/pharma_nav.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewPharmacyRequests extends StatefulWidget {
  const ViewPharmacyRequests({Key? key}) : super(key: key);

  @override
  State<ViewPharmacyRequests> createState() => _ViewPharmacyRequestsState();
}

class _ViewPharmacyRequestsState extends State<ViewPharmacyRequests> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Define a list to hold your telemedicine requests
  List<TelemedicineRequestModel> _telemedicineRequests = [];

  @override
  void initState() {
    super.initState();
    // Fetch telemedicine requests when the widget is built
    fetchTelemedicineRequests();
  }

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
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        titleSpacing: 0.0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
              ],
            ),
            Expanded(
              child: Center(child: Text('View Requests', style: TextStyle(color: Colors.white),)),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  ap.userSignOut().then(
                        (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PharmaHome(),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.exit_to_app, color: Colors.white,),
              ),
            ],
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _telemedicineRequests.length,
        itemBuilder: (context, index) {
          var request = _telemedicineRequests[index];
          return buildRequestCard(request);
        },
      ),
      drawer: const PharmaNav(),
    );
  }

  Widget buildRequestCard(TelemedicineRequestModel request) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine: ${request.medicine}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Name: ${request.name}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Email: ${request.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Phone: ${request.phoneNumber}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Address: ${request.address}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Text(
              'State: ${request.state}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  // Open the file URL using url_launcher
                  if (await canLaunch(request.fileURL)) {
                    await launch(request.fileURL);
                  } else {
                    // Handle error if unable to launch the URL
                    print('Could not launch ${request.fileURL}');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('Download Prescription', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }



  // Function to fetch telemedicine requests data
  Future<void> fetchTelemedicineRequests() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    // Extract pharmacyId from email (assuming the email format is 'pharmacyId@atomdyno.com')
    String pharmacyId = email.split('@')[0];

    // Limit the number of documents to fetch initially
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("telemedicine_requests")
        .where('pharmacyId', isEqualTo: pharmacyId)
        .limit(10) // Adjust the limit based on your needs
        .get();

    setState(() {
      _telemedicineRequests = querySnapshot.docs.map((doc) {
        return TelemedicineRequestModel(
          name: doc['name'],
          phoneNumber: doc['phoneNumber'],
          uid: doc['uid'],
          address: doc['address'],
          city: doc['city'],
          email: doc['email'],
          fileURL: doc['fileURL'],
          medicine: doc['medicine'],
          pharmacy: doc['pharmacy'],
          pharmacyId: doc['pharmacyId'],
          state: doc['state'],
            orderId: doc['orderId']
        );
      }).toList();
    });

    if (mounted) {
      setState(() {}); // Ensure the UI rebuilds after fetching data
    }
  }
}

// Model class to represent telemedicine request data
class TelemedicineRequestModel {
  final String name;
  final String phoneNumber;
  final String uid;
  final String address;
  final String city;
  final String email;
  final String fileURL;
  final String medicine;
  final String pharmacy;
  final String pharmacyId;
  final String state;
  final String orderId;

  TelemedicineRequestModel({
    required this.name,
    required this.phoneNumber,
    required this.uid,
    required this.address,
    required this.city,
    required this.email,
    required this.fileURL,
    required this.medicine,
    required this.pharmacy,
    required this.pharmacyId,
    required this.state,
    required this.orderId
  });
}

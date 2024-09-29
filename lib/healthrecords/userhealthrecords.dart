import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:medapp/screens/home_screen.dart';

import '../Navigation/menu.dart';

class UserRecords extends StatefulWidget {
  const UserRecords({Key? key}) : super(key: key);

  @override
  State<UserRecords> createState() => _UserRecordsState();
}

class _UserRecordsState extends State<UserRecords> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  TextEditingController userPhoneNumberController = TextEditingController();
  String eHealthRecord = '';
  String recordName = '';
  String downloadURL = '';

  Future<void> _fetchEHealthRecord() async {
    String userPhoneNumber = userPhoneNumberController.text;

    // Retrieve eHealth record from Firestore based on user's phone number
    DocumentSnapshot snapshot =
    await FirebaseFirestore.instance.collection('e_health_records').doc(userPhoneNumber).get();

    if (snapshot.exists) {
      setState(() {
        eHealthRecord = snapshot.toString(); // Update eHealth record in the state
        recordName = snapshot['recordName']; // Assuming 'recordName' is the field for the record name
        downloadURL = snapshot['downloadURL']; // Assuming 'downloadURL' is the field for the download URL
      });
    } else {
      setState(() {
        eHealthRecord = 'No eHealth record found for the given phone number';
        recordName = '';
        downloadURL = '';
      });
    }
  }

  Future<void> _downloadRecord() async {
    if (downloadURL.isNotEmpty) {
      await canLaunch(downloadURL) ? await launch(downloadURL) : throw 'Could not launch $downloadURL';
    } else {
      // Show an error message or snackbar indicating no download URL available
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download URL not available')));
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
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Upload Health Report", style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: userPhoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Enter Your Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _fetchEHealthRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Fetch eHealth Record"),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Record Name: $recordName",
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _downloadRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text("Download eHealth Record"),
            ),
            const SizedBox(height: 16.0),
            Text(
              eHealthRecord,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ),
      ),
      drawer: const Navigation(),
    );
  }
}

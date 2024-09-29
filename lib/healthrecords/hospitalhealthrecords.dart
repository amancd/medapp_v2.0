import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../hospitals/hospital_home.dart';
import '../hospitals/hospital_nav.dart';

class HUploadDocs extends StatefulWidget {
  const HUploadDocs({Key? key}) : super(key: key);

  @override
  State<HUploadDocs> createState() => _HUploadDocsState();
}

class _HUploadDocsState extends State<HUploadDocs> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

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
                MaterialPageRoute(builder: (context) => const HPage()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UploadHealthReportScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Upload Health Report",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SearchHealthReportScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text(
                "Search Health Report",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
      drawer: const HNav(),
    );
  }
}

class UploadHealthReportScreen extends StatefulWidget {
  const UploadHealthReportScreen({Key? key}) : super(key: key);

  @override
  _UploadHealthReportScreenState createState() => _UploadHealthReportScreenState();
}

class _UploadHealthReportScreenState extends State<UploadHealthReportScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  File? _selectedFile;
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController reportNameController = TextEditingController();

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null) {
      // Show an error message or snackbar indicating no file selected
      return;
    }

    String phoneNumber = phoneNumberController.text;
    String reportName = reportNameController.text;

    Reference storageReference =
    FirebaseStorage.instance.ref().child('health_reports/$phoneNumber/$reportName.pdf');

    UploadTask uploadTask = storageReference.putFile(_selectedFile!);

    await uploadTask.whenComplete(() => null);

    String downloadURL = await storageReference.getDownloadURL();

    // Save file metadata to Firestore
    await FirebaseFirestore.instance.collection('health_reports').doc(phoneNumber).set({
      'file_url': downloadURL,
      'timestamp': FieldValue.serverTimestamp(),
      'phoneNumber': phoneNumber,
      'reportName': reportName,
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File Uploaded Successfully!')));
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
                MaterialPageRoute(builder: (context) => const HPage()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Enter Customer Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: reportNameController,
                  decoration: const InputDecoration(
                    labelText: "Enter Health Report Name",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _selectFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Select PDF File"),
                ),
                const SizedBox(height: 16.0),
                if (_selectedFile != null)
                  Text("Selected File: ${_selectedFile!.path}"),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _uploadFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Upload Health Report"),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const HNav(),
    );
  }
}

class SearchHealthReportScreen extends StatefulWidget {
  const SearchHealthReportScreen({Key? key}) : super(key: key);

  @override
  _SearchHealthReportScreenState createState() => _SearchHealthReportScreenState();
}

class _SearchHealthReportScreenState extends State<SearchHealthReportScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextEditingController phoneNumberController = TextEditingController();
  String? downloadURL;
  String? reportName;

  Future<void> _searchFile() async {
    String phoneNumber = phoneNumberController.text;

    // Retrieve the download URL and report name from Firestore
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('health_reports').doc(phoneNumber).get();

    if (snapshot.exists) {
      setState(() {
        downloadURL = snapshot['file_url'];
        reportName = snapshot['reportName'];
      });
    } else {
      // Show an error message or snackbar indicating no file found
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File not found for the given phone number')));
    }
  }

  Future<void> _openPDF() async {
    if (downloadURL != null) {
      await canLaunch(downloadURL!) ? await launch(downloadURL!) : throw 'Could not launch $downloadURL';
    } else {
      // Show an error message or snackbar indicating no file to open
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('File not found')));
    }
  }

  Future<void> _deleteReport() async {
    String phoneNumber = phoneNumberController.text;

    // Delete the report from Firestore
    await FirebaseFirestore.instance.collection('health_reports').doc(phoneNumber).delete();

    setState(() {
      downloadURL = null;
      reportName = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report deleted successfully')));
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
        title: const Text("Search Health Report", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HPage()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Enter Customer Phone Number",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _searchFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text("Search Health Report"),
                ),
                const SizedBox(height: 16.0),
                if (reportName != null)
                  Text("Report Name: $reportName"),
                const SizedBox(height: 16.0),
                if (downloadURL != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: _openPDF,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text("Open PDF"),
                      ),
                      ElevatedButton(
                        onPressed: _deleteReport,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text("Delete Report"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      drawer: const HNav(),
    );
  }
}

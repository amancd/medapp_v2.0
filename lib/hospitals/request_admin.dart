import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medapp/hospitals/hospital_nav.dart';

class RequestAdmin extends StatefulWidget {
  const RequestAdmin({Key? key}) : super(key: key);

  @override
  _RequestAdminState createState() => _RequestAdminState();
}

class _RequestAdminState extends State<RequestAdmin> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? Colors.green,
      ),
    );
  }

  void _sendRequestToAdmin() async {
    // Get the values from controllers
    String comment = _commentController.text;
    String email = _emailController.text;
    User? user = FirebaseAuth.instance.currentUser;
    String username = user?.email ?? '';

    String hospitalId = username.split('@')[0];
    try {
      // Reference to the collection 'request_admin' and document with hospitalId
      CollectionReference requests =
      FirebaseFirestore.instance.collection('request_admin');
      DocumentReference requestDoc = requests.doc(hospitalId);

      // Check if the document already exists
      if ((await requestDoc.get()).exists) {
        // Document exists, update the fields
        await requestDoc.update({
          'comment': comment,
          'email': email,
          'hospitalId': hospitalId,
          // Add other fields as needed
        });
      } else {
        // Document doesn't exist, create a new one
        await requestDoc.set({
          'hospitalId': hospitalId,
          'comment': comment,
          'email': email,
          'reply': '', // Initialize reply as an empty string
          // Add other fields as needed
        });
      }

      // Show a success message
      _showSnackBar('Request sent successfully');
    } catch (e) {
      // Show an error message
      _showSnackBar('Error sending request: $e', backgroundColor: Colors.red);
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
          title: const Text("Need Help", style: TextStyle(color: Colors.white)),
        ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email ID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Validate and send the request to the database
                _sendRequestToAdmin();
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
                  'Send Request',
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
    ),
        drawer: const HNav(),
    );
  }
}

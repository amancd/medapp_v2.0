import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medapp/hospitals/hospital_home.dart';
import 'package:medapp/hospitals/hospital_nav.dart';

class AdminReplyPage extends StatefulWidget {
  const AdminReplyPage({Key? key}) : super(key: key);

  @override
  _AdminReplyPageState createState() => _AdminReplyPageState();
}

class _AdminReplyPageState extends State<AdminReplyPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<String> _adminReplies = [];

  @override
  void initState() {
    super.initState();
    fetchAdminReplies();
  }

  Future<void> fetchAdminReplies() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    String hospitalId = email.split('@')[0];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("request_admin")
          .where('hospitalId', isEqualTo: hospitalId)
          .get();

      setState(() {
        _adminReplies = querySnapshot.docs.map((doc) {
          return doc['reply'] as String;
        }).toList();
      });

      print('Admin Replies: $_adminReplies'); // Add this line for debugging
    } catch (e) {
      print('Error fetching admin replies: $e');
    }
    if (mounted) {
      setState(() {});
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
        title: const Text("Notifications", style: TextStyle(color: Colors.white)),
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
      body: ListView.builder(
        itemCount: _adminReplies.length,
        itemBuilder: (context, index) {
          String reply = _adminReplies[index];
          return reply.isNotEmpty
              ? Card(
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                reply,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          )
              : const Center(
            child: Text("No notifications"),
          );
        },
      ),
      drawer: const HNav(),
    );
  }
}


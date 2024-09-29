import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medapp/admin/admin_nav.dart';
import '../profilepage/userprofile.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key? key}) : super(key: key);

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<User> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsersData();
  }

  Future<void> fetchUsersData() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      if (mounted) {
        setState(() {
          _users = querySnapshot.docs.map((doc) {// Print document data
            return User.fromMap(doc.data() as Map<String, dynamic>);
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching users data: $e');
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
        title: const Text("All Users", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const UserProfile()),
              );
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: _users != null
          ? ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return UserCard(user: _users[index]);
        },
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
      drawer: const AdminNav(),
    );
  }
}

class User {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String bio;
  final String blood;
  final String createdAt;
  final String date;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.bio,
    required this.blood,
    required this.createdAt,
    required this.date,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      bio: map['bio'] ?? '',
      blood: map['blood'] ?? '',
      createdAt: map['createdAt'] ?? '',
      date: map['date'] ?? '',
    );
  }
}

class UserCard extends StatelessWidget {
  final User user;

  UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          'UserID: ${user.userId}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Name: ${user.name}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Email: ${user.email}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            // Add other user details as needed
          ],
        ),
        onTap: () {
          _showUserDetailsDialog(context, user);
        },
      ),
    );
  }

  void _showUserDetailsDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('User Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Name:', user.name),
              _buildDetailRow('Email:', user.email),
              _buildDetailRow('Phone:', user.phoneNumber),
              _buildDetailRow('DOB:', user.date),
              _buildDetailRow('Blood:', user.blood),
              _buildDetailRow('Address:', user.bio),
              // Add other user details as needed
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}


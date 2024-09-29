import 'package:flutter/material.dart';
import 'package:medapp/profilepage/text_box.dart';
import 'package:provider/provider.dart';

import '../Navigation/menu.dart';
import '../provider/auth_provider.dart';
import '../screens/welcome_screen.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(context: context, builder: (context) =>
        AlertDialog(
          title: Text("Edit $field"),
          content: TextField(
            autofocus: true,
            style: const TextStyle(
                color: Colors.purple
            ),
            decoration: InputDecoration(
              hintText: "Enter new $field",
              hintStyle: const TextStyle(color: Colors.grey),
            ),
            onChanged: (value) {
              newValue = value;
            },
          ),

          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: const Text(
                    "Cancel", style: TextStyle(color: Colors.purple))),
            TextButton(onPressed: () => Navigator.of(context).pop(newValue),
                child: const Text(
                "Save", style: TextStyle(color: Colors.purple)))
          ],
        ),
    );
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
          centerTitle: true,
          backgroundColor: Colors.deepPurpleAccent,
          title: const Text(
              "User Profile", style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () {
                ap.userSignOut().then(
                      (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.exit_to_app, color: Colors.white),
            ),
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(height: 30),

            const Icon(Icons.person, size: 60),

            const Text("My Details",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black),),

            const SizedBox(height: 10,),

            MyTextBox(text: ap.userModel.name,
                sectionName: 'Name:',
                onPressed: () => editField('name')),

            MyTextBox(text: ap.userModel.email,
                sectionName: 'Email:',
                onPressed: () => editField('email')),

            MyTextBox(text: ap.userModel.phoneNumber,
                sectionName: 'Phone Number:',
                onPressed: () => editField('phone')),

            MyTextBox(text: ap.userModel.date,
                sectionName: 'Date of Birth:',
                onPressed: () => editField('date of birth')),

            MyTextBox(text: ap.userModel.blood,
                sectionName: 'Blood Group:',
                onPressed: () => editField('Blood Group')),

            MyTextBox(text: ap.userModel.bio,
                sectionName: 'Address:',
                onPressed: () => editField('address')),
          ],
        ),
      drawer: const Navigation(),
    );
  }
}

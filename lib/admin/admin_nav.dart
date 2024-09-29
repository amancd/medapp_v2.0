import 'package:flutter/material.dart';
import 'package:medapp/TeleMedicine/admin_telemedicine.dart';
import 'package:medapp/admin/add_doctors.dart';
import 'package:medapp/admin/add_hospitals.dart';
import 'package:medapp/admin/admin_chat.dart';
import 'package:medapp/admin/admin_home.dart';
import 'package:medapp/admin/all_users.dart';
import 'package:medapp/admin/viewbookings.dart';

class AdminNav extends StatelessWidget {
  const AdminNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ));
  }
}

Widget buildHeader(BuildContext context) {
  return Material(
    child: InkWell(
      child: Container(
        color: Colors.deepOrange,
        padding: EdgeInsets.only(
          top: 10 + MediaQuery
              .of(context)
              .padding
              .top,
          bottom: 24,),
        child: const Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage("assets/logo.jpg"),
            ),
            Text(
              'HIMS',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w500),
            ),
            Center(
              child: Text(
                "\"Hindustan Integrated Medical Services\"",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget buildMenuItems(BuildContext context) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(20),
    child: Wrap(
      runSpacing: 8,
      children: [
        ListTile(
          leading: const Icon(Icons.home, color: Colors.black),
          title: const Text("Home", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminHome()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month, color: Colors.black),
          title: const Text("View Bookings",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ViewBookings()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.black),
          title: const Text("Add Hospitals",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddHospitals()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.black),
          title: const Text("Add Doctors",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddDoctorsPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.medical_services, color: Colors.black),
          title: const Text("Add Medicines",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ATeleMedicine()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.verified_user, color: Colors.black),
          title: const Text("All Users", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AllUsers()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat, color: Colors.black),
          title: const Text("Support", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ChatApp()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.share, color: Colors.black),
          title: const Text("Share", style: TextStyle(color: Colors.black)),
          onTap: () {

          },
        ),
        const Divider(
          height: 5,
          thickness: 0.5,
          color: Colors.black,
        ),

        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(child: Text("TEAM CAREMATES")),
        )
      ],
    ),
  );
}
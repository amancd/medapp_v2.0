import 'package:flutter/material.dart';
import 'package:medapp/TeleMedicine/h_telemedicine.dart';
import 'package:medapp/hospitals/add_doctors.dart';
import 'package:medapp/hospitals/approve_booking.dart';
import 'package:medapp/hospitals/edit_hospital.dart';
import 'package:medapp/hospitals/hospital_home.dart';
import 'package:medapp/hospitals/request_admin.dart';
import 'package:medapp/hospitals/viewdoctors.dart';

import '../healthrecords/hospitalhealthrecords.dart';

class HNav extends StatelessWidget {
  const HNav({Key? key}) : super(key: key);

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
              'HIMS Hospital',
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
              MaterialPageRoute(builder: (context) => const HPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month, color: Colors.black),
          title: const Text("Approve Bookings",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ApproveBookings()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.upload, color: Colors.black),
          title: const Text("Upload Health Reports",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HUploadDocs()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.edit, color: Colors.black),
          title: const Text("Edit Details",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EditHospitals()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.add, color: Colors.black),
          title: const Text("Add Doctors",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HAddDoctorsPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.black),
          title: const Text("View Doctors",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ViewDoctors()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.medical_services, color: Colors.black),
          title: const Text("Approve Request",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HTeleMedicine()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.help_outline, color: Colors.black),
          title: const Text("Request Admin", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RequestAdmin()),
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
          child: Center(child: Text("💖 TEAM CAREMATES")),
        )
      ],
    ),
  );
}
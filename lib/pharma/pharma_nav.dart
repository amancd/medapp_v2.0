import 'package:flutter/material.dart';
import 'package:medapp/pharma/pabout.dart';
import 'package:medapp/pharma/pfeedback.dart';
import 'package:medapp/pharma/view_requests.dart';

import 'Pharma_home.dart';
import 'approve_requests.dart';
import 'delivery.dart';


class PharmaNav extends StatelessWidget {
  const PharmaNav({Key? key}) : super(key: key);

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
              'HIMS Pharma',
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
              MaterialPageRoute(builder: (context) => const PharmaHome()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.medical_services, color: Colors.black),
          title: const Text("View Requests",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ViewPharmacyRequests()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.check, color: Colors.black),
          title: const Text("Approve Requests",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ApprovePharmacyRequests()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delivery_dining, color: Colors.black),
          title: const Text("Delivery",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => DeliveryPage()),
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

        ListTile(
          leading: const Icon(Icons.description, color: Colors.black),
          title: const Text("About", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PAbout()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback, color: Colors.black),
          title: const Text("Feedback", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PFeedbacks()),
            );
          },
        ),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(child: Text("TEAM CAREMATES")),
        ),

      ],
    ),
  );
}
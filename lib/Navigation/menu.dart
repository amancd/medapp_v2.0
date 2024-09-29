import 'package:flutter/material.dart';
import 'package:medapp/ChatSystem/chat.dart';
import 'package:medapp/Emergency/emergency.dart';
import 'package:medapp/IoMT.dart';
import 'package:medapp/booking/meeting.dart';
import 'package:medapp/booking/viewbooking.dart';
import 'package:medapp/healthrecords/userhealthrecords.dart';
import 'package:medapp/hospitals/all_hospitals.dart';
import 'package:medapp/pages/disclaimer.dart';
import 'package:medapp/pages/feedbacks.dart';
import 'package:medapp/screens/home_screen.dart';

import '../TeleMedicine/h_telemedicine.dart';
import '../pages/about.dart';
import '../pages/privacy.dart';


class Navigation extends StatelessWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 260,
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
        padding: EdgeInsets.only(
          top: 10 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Stack(
          children: [
            // Background image
            Container(
              width: double.infinity,
              height: 180, // Adjust the height as needed
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/doctor.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Content on top of the background
            const Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/logo.jpg"),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'HIMS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Center(
                  child: Text(
                    "\"Hindustan Integrated Medical Services\"",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
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
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.calendar_month, color: Colors.black),
          title: const Text("Book Appointment",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const OnlineAppointment()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.book, color: Colors.black),
          title: const Text("View Bookings",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ViewBooking()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.monitor_heart_sharp, color: Colors.black),
          title: const Text("E-Health Record",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const UserRecords()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_hospital, color: Colors.black),
          title: const Text("All Hospitals", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AllHospitals()),
            );
          },
        ),
        // ListTile(
        //   leading: const Icon(Icons.mail, color: Colors.black),
        //   title: const Text("Outlook", style: TextStyle(color: Colors.black)),
        //   onTap: () async {
        //     var teamsAppUrl = 'outlook:';
        //     try {
        //       await launchUrlString(teamsAppUrl); // Attempt to launch the Teams app
        //     } catch (e) {
        //       var openAppResult = await LaunchApp.openApp(
        //         androidPackageName: 'com.microsoft.office.outlook',
        //         iosUrlScheme: 'outlook:',
        //       );// Open the Play Store page for the Teams app
        //     }
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.group, color: Colors.black),
        //   title: const Text("Teams", style: TextStyle(color: Colors.black)),
        //   onTap: () async {
        //     var teamsAppUrl = 'msteams:';
        //     try {
        //       await launchUrlString(teamsAppUrl); // Attempt to launch the Teams app
        //     } catch (e) {
        //       var openAppResult = await LaunchApp.openApp(
        //         androidPackageName: 'com.microsoft.teams',
        //         iosUrlScheme: 'msteams:',
        //       );// Open the Play Store page for the Teams app
        //     }
        //   },
        // ),
        ListTile(
          leading: const Icon(Icons.call, color: Colors.black),
          title: const Text("Emergency", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EmergencyPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.sensor_occupied, color: Colors.black),
          title: const Text("IoMT", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const IOMT()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.medical_services, color: Colors.black),
          title: const Text("TeleMedicine", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HTeleMedicine()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.chat, color: Colors.black),
          title: const Text("Chat With Ved", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => UserChatApp()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.share, color: Colors.black),
          title: const Text("Share", style: TextStyle(color: Colors.black)),
          onTap: () {
            // shareAppLink();
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
              MaterialPageRoute(builder: (context) => About()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.error, color: Colors.black),
          title:
          const Text("Disclaimer", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Disclaimer()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.policy, color: Colors.black),
          title: const Text("Privacy Policy",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Privacy()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.feedback, color: Colors.black),
          title: const Text("Feedback", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Feedbacks()),
            );
          },
        ),
      ],
    ),
  );
}
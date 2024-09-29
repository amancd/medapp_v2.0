import 'package:flutter/material.dart';
import 'package:medapp/admin/add_doctors.dart';
import 'package:medapp/admin/add_hospitals.dart';
import 'package:medapp/admin/admin_chat.dart';
import 'package:medapp/admin/admin_nav.dart';
import 'package:medapp/admin/viewbookings.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../provider/auth_provider.dart';
import '../screens/welcome_screen.dart';

import 'all_users.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Card makeDashboardItem(String title, IconData icon, int index) {
    List<Color> gradientColors;
    if (index == 0 || index == 3 || index == 4) {
      gradientColors = [
        const Color(0xFF5170FF),
        const Color(0xFF5170FF),
      ];
    } else {
      gradientColors = [
        const Color(0xFF5170FF),
        const Color(0xFF5170FF),
      ];
    }


    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Adjust the margin as per your requirements
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(color: Colors.white),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(3.0, -1.0),
            colors: gradientColors,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 3,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminHome()),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddHospitals()),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewBookings()),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AllUsers()),
              );
            }
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddDoctorsPage()),
              );
            }
            if (index == 5) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatApp()),
              );
            }
            if (index == 6) {
              shareAppLink;
            }
            if (index == 7) {

            }
            if (index == 8) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
              );
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.yellowAccent,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
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
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        titleSpacing: 0.0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
              ],
            ),
            Expanded(
                child: Center(child: Text('Home', style: TextStyle(color: Colors.white),))
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    ap.userSignOut().then(
                          (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                      ),);
                  }, icon: const Icon(Icons.exit_to_app, color: Colors.white,)),
            ],
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 4),
                  Center(
                      child: Container(
                        color: Colors.deepOrangeAccent,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("You logged in as admin!", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                      )
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3, // 3 columns
              padding: const EdgeInsets.all(8),
              mainAxisSpacing: 8, // spacing between items vertically
              crossAxisSpacing: 8, // spacing between items horizontally
              children: [
                makeDashboardItem("Home", Icons.home, 0),
                makeDashboardItem("Add Hospitals", Icons.local_hospital, 1),
                makeDashboardItem("Bookings", Icons.calendar_month, 2),
                makeDashboardItem("All Users", Icons.group, 3),
                makeDashboardItem("Add Doctors", Icons.add, 4),
                makeDashboardItem("Support", Icons.chat, 5),
                makeDashboardItem("Share", Icons.share, 6),
                makeDashboardItem("Locked", Icons.lock, 7),
                makeDashboardItem("Logout", Icons.exit_to_app, 8),
              ],
            ),
          ),
        ],
      ),
      drawer: const AdminNav(),
    );
  }
}

void shareAppLink() {
  String message = 'Download HIMS App For Appointments, medical support and much more.\n\n';
  String playStoreLink = 'https://play.google.com/store/apps/details?id=com.apna.au.app';
  String shareText = message + playStoreLink;
  print("Function gets called");
  Share.share(shareText);
}
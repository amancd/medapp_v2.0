import 'package:flutter/material.dart';
import 'package:medapp/hospitals/add_doctors.dart';
import 'package:medapp/hospitals/adminreply.dart';
import 'package:medapp/hospitals/approve_booking.dart';
import 'package:medapp/hospitals/edit_hospital.dart';
import 'package:medapp/hospitals/hospital_nav.dart';
import 'package:medapp/hospitals/request_admin.dart';
import 'package:medapp/hospitals/viewdoctors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';


import '../provider/auth_provider.dart';
import '../screens/welcome_screen.dart';

class HPage extends StatefulWidget {
  const HPage({Key? key}) : super(key: key);

  @override
  State<HPage> createState() => _HPageState();
}

class _HPageState extends State<HPage> {
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
                MaterialPageRoute(builder: (context) => const HPage()),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ApproveBookings()),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditHospitals()),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HAddDoctorsPage()),
              );
            }
            if (index == 4) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewDoctors()),
              );
            }
            if (index == 5) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RequestAdmin()),
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
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminReplyPage(),
                        ),
                      );
                  }, icon: const Icon(Icons.notifications, color: Colors.white,)),
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
                          child: Text("You logged in as hospital admin!", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),),
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
                makeDashboardItem("Approve", Icons.calendar_month, 1),
                makeDashboardItem("Edit Details", Icons.edit, 2),
                makeDashboardItem("Add Doctors", Icons.add, 3),
                makeDashboardItem("View Doctors", Icons.person, 4),
                makeDashboardItem("Request", Icons.help_outline, 5),
                makeDashboardItem("Share", Icons.share, 6),
                makeDashboardItem("Locked", Icons.lock, 7),
                makeDashboardItem("Logout", Icons.exit_to_app, 8),
              ],
            ),
          ),
        ],
      ),
      drawer: const HNav(),
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
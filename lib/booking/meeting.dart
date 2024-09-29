import 'package:flutter/material.dart';
import 'package:medapp/booking/selectcategory.dart';

import '../Navigation/menu.dart';

class OnlineAppointment extends StatefulWidget {
  const OnlineAppointment({Key? key}) : super(key: key);

  @override
  State<OnlineAppointment> createState() => _OnlineAppointmentState();
}

class _OnlineAppointmentState extends State<OnlineAppointment> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

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
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Bookings", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectCategory(type: 'Book Virtual Meeting'),
                  ),
                );
              },
              icon: const Icon(Icons.videocam),
              label: const Text('Virtual Meeting'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Add some space between buttons
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectCategory(type: 'Book Offline Appointment'),
                  ),
                );
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Book Appointment'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const Navigation(),
    );
  }
}

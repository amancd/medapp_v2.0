import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Navigation/menu.dart';
import '../model/booking_model.dart';
import '../profilepage/userprofile.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class ViewBooking extends StatefulWidget {
  const ViewBooking({Key? key}) : super(key: key);

  @override
  State<ViewBooking> createState() => _ViewBookingState();
}

class _ViewBookingState extends State<ViewBooking> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<BookingModel> _bookings = [];
  String? _uid;
  @override
  void initState() {
    super.initState();
    fetchBookingsData();
  }

  Future<void> fetchBookingsData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    _uid = ap.userModel.uid;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .where('userId', isEqualTo: _uid)
          .get();

      setState(() {
        _bookings = querySnapshot.docs.map((doc) {
          return BookingModel(
            username: doc['username'],
            phoneNumber: doc['phoneNumber'],
            userId: doc['userId'],
            selectedDay: doc['selectedDay'],
            selectedTimeSlot: doc['selectedTimeSlot'],
            doctorName: doc['doctorName'],
            hospitalName: doc['hospitalName'],
            specialty: doc['specialty'],
            bookingId: doc['bookingId'],
            hospitalId: doc['hospitalId'],
            status: doc['status'],
            type: doc['type']
          );
        }).toList();
      });
    if (mounted) {
      setState(() {}); // Ensure the UI rebuilds after fetching data
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
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text("Upcoming", style: TextStyle(color: Colors.white)),
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
      body: _bookings.isEmpty
          ? const Center(
        child: Text("No Bookings"),
      )
          :ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          BookingModel booking = _bookings[index];

          // Parse the selectedDay as a DateTime
          DateTime selectedDay = DateFormat('dd-MM-yyyy').parse(booking.selectedDay);

          // Check if the appointment is upcoming based on the selected day
          if (selectedDay.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
              return Dismissible(
                key: Key('${booking.userId}_$index'),
                // Use a unique key for each item
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  // You can add a confirmation dialog here if needed
                  return true;
                },
                  child:Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        gradient: const LinearGradient(
                          colors: [Colors.deepOrangeAccent, Colors.redAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Status: ${booking.status}',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            const SizedBox(height: 20),
                            Text(
                              'Day: ${booking.selectedDay}',
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Time Slot: ${booking.selectedTimeSlot}',
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Doctor: ${booking.doctorName}',
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Specialty: ${booking.specialty}',
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Hospital: ${booking.hospitalName}',
                              style: const TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                        tileColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
              );
            } else {
              return const Center(child: Text("No Bookings"));
            }
          }
      ),
      drawer: const Navigation(),
    );
  }
}

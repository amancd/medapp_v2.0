import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/hospitals/add_doctors.dart';

import '../model/booking_model.dart';
import 'hospital_nav.dart';

class ApproveBookings extends StatefulWidget {
  const ApproveBookings({Key? key}) : super(key: key);

  @override
  State<ApproveBookings> createState() => _ApproveBookingsState();
}

class _ApproveBookingsState extends State<ApproveBookings> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookingsData();
  }

  Future<void> fetchBookingsData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String email = user?.email ?? '';

    // Extract hospitalId from email (assuming the email format is 'hospitalId@atomdyno.com')
    String hospitalId = email.split('@')[0];

    // Limit the number of documents to fetch initially
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("bookings")
        .where('hospitalId', isEqualTo: hospitalId)
        .limit(10) // Adjust the limit based on your needs
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
          type: doc['type'],
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
        backgroundColor: Colors.deepOrange,
        title: const Text("Approve Bookings",
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const HAddDoctorsPage()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: _bookings.isEmpty
          ? const Center(
        child: Text("No Bookings"),
      )
          : ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          BookingModel booking = _bookings[index];

          // Parse the selectedDay as a DateTime
          DateTime selectedDay =
          DateFormat('dd-MM-yyyy').parse(booking.selectedDay);

          // Check if the appointment is upcoming based on the selected day
          if (selectedDay
              .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
            return Dismissible(
                key: Key('${booking.userId}_$index'),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  elevation: 2.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // Show dialog on card tap
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Approve or reject this booking!",
                                style: TextStyle(fontSize: 16)),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle Approve
                                    approveBooking(booking);
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.green, // text color
                                  ),
                                  child: const Text("Approve"),
                                ),
                                const SizedBox(height: 16),
                                // Add some space between buttons
                                ElevatedButton(
                                  onPressed: () {
                                    // Handle Reject
                                    rejectBooking(booking);
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red, // text color
                                  ),
                                  child: const Text("Reject"),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurpleAccent, Colors.deepOrange],
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
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            const SizedBox(height: 10.0),
                            Text(
                              'Day: ${booking.selectedDay}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Time Slot: ${booking.selectedTimeSlot}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Name: ${booking.username}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Phone: ${booking.phoneNumber}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Doctor: ${booking.doctorName}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Specialty: ${booking.specialty}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Booking Type: ${booking.type}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'UserId: ${booking.userId}',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
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
                ));
          } else {
            // Return an empty container for past bookings
            return const Center(
                child: Text("No Bookings!")
            );
          }
        },
      ),
      drawer: const HNav(),
    );
  }

  void approveBooking(BookingModel booking) async {
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(booking.bookingId)
        .update({'status': 'Approved'});

    fetchBookingsData();
  }

  void rejectBooking(BookingModel booking) async {
     // Ensure the UI rebuilds after fetching data
    reason(booking);
  }

  void reason(BookingModel booking) {
    TextEditingController _reasonController = TextEditingController();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Enter the reason for rejection", style: TextStyle(fontSize: 16),),
            content: TextField(
              controller: _reasonController,
              decoration: const InputDecoration(labelText: 'Reason'),
            ),
            actions: [
              ElevatedButton(
                child: const Text('Reject', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  String reason = _reasonController.text.trim();
                  await FirebaseFirestore.instance
                      .collection('bookings')
                      .doc(booking.bookingId)
                      .update({'status': "Rejected\nReason: $reason"});

                  // Close the dialog
                  Navigator.of(context).pop();

                  fetchBookingsData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    });
  }

}

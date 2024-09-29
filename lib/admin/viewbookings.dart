import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/admin/add_doctors.dart';
import 'package:medapp/admin/admin_nav.dart';
import '../model/booking_model.dart';

class ViewBookings extends StatefulWidget {
  const ViewBookings({Key? key}) : super(key: key);

  @override
  State<ViewBookings> createState() => _ViewBookingsState();
}

class _ViewBookingsState extends State<ViewBookings> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<BookingModel> _bookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookingsData();
  }

  Future<void> fetchBookingsData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("bookings")
          .orderBy('selectedDay')
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
    } catch (e) {
      print('Error fetching booking data: $e');
    }
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
        title: const Text("View Bookings", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddDoctorsPage()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          BookingModel booking = _bookings[index];

          // Parse the selectedDay as a DateTime
          DateTime selectedDay = DateFormat('dd-MM-yyyy').parse(booking.selectedDay);

          // Check if the appointment is upcoming based on the selected day
          if (selectedDay.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
            return Dismissible(
              key: Key('${booking.userId}_$index'),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Deletion"),
                      content: const Text("Are you sure you want to delete this booking?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text("Delete"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              onDismissed: (direction) {
                print('Deleting booking: ${booking.userId}');
                deleteBooking(index);
              },
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
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
                          'Phone: ${booking.phoneNumber}',
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
                        const SizedBox(height: 4.0),
                        Text(
                          'UserId: ${booking.userId}',
                          style: const TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.delete, color: Colors.white),
                    tileColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Return an empty container for past bookings
            return Container();
          }
        },
      ),
      drawer: const AdminNav(),
    );
  }

  // Function to delete a booking
  void deleteBooking(int index) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(_bookings[index].userId)
          .delete();
      setState(() {
        _bookings.removeAt(index);
      });
    } catch (e) {
      print('Error deleting booking: $e');
      // Handle the error, show a message, etc.
    }
  }
}

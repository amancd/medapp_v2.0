import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/booking/viewbooking.dart';
import 'package:medapp/profilepage/userprofile.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

import '../Navigation/menu.dart';
import '../provider/auth_provider.dart';
import 'package:medapp/model/booking_model.dart';

class BookingPage extends StatefulWidget {
  final String hospitalName;
  final String doctorName;
  final String specialty;
  final String hospitalId;
  final String type;

  const BookingPage({Key? key, required this.hospitalName,
    required this.doctorName,
    required this.specialty,
    required this.type,
    required this.hospitalId}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<String> timeSlots = [
    '8:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '1:00 PM - 3:00 PM',
    '3:00 PM - 5:00 PM',
    '6:00 PM - 8:00 PM',
  ];
  String _selectedTimeSlot = "";
  int _selectedSlotIndex = -1;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  String? _uid;

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
        title: const Text("Appointment", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const UserProfile()));
            },
            icon: const Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Row for Upcoming and Completed buttons
          Padding(
            padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showUpcomingAppointments();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  ),
                  child: const Text('Upcoming', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    showCompletedAppointments();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
                  ),
                  child: const Text('Completed', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Adjust the spacing as needed

          // Your calendar widget goes here
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Define the condition for a day to be considered as selected
              return isSameDay(day, _selectedDay);
            },
            enabledDayPredicate: (day) {
              // Allow selection of future dates only
              return day.isAfter(DateTime.now().subtract(const Duration(days: 0)));
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update _focusedDay as well
              });
            },
            calendarStyle: const CalendarStyle(
              // Custom styling for past dates
              disabledTextStyle: TextStyle(color: Colors.grey),
            ),
            calendarBuilders: const CalendarBuilders(),
          ),
          const SizedBox(height: 20),

          // Display time slots conditionally based on the selected day
          if (_selectedDay.weekday != DateTime.sunday)
            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedTimeSlot = timeSlots[index];
                        _selectedSlotIndex = index;
                      });
                    },
                    child: Card(
                      // Customize card styling as needed
                      color: _selectedSlotIndex == index
                          ? Colors.deepOrange // Change color for the selected slot
                          : Colors.deepPurpleAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          timeSlots[index],
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ElevatedButton(onPressed: storeBookingData, style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange)), child: const Text("Book Now", style: TextStyle(color: Colors.white)),)
        ],
      ),
      drawer: const Navigation(),
    );
  }

  void showUpcomingAppointments() {
    fetchBookingDataFromFirestore(_firebaseFirestore, isUpcoming: true);
  }

  void showCompletedAppointments() {
    fetchBookingDataFromFirestore(_firebaseFirestore, isUpcoming: false);
  }

  Future<void> fetchBookingDataFromFirestore(FirebaseFirestore firestore, {required bool isUpcoming}) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection("bookings")
          .where('userId', isEqualTo: _uid)
          .get();

      List<BookingModel> upcomingAppointments = [];
      List<BookingModel> completedAppointments = [];

      User? user = _firebaseAuth.currentUser;
      String phoneNumber = user?.phoneNumber ?? '';

      querySnapshot.docs.forEach((doc) {
        BookingModel bookingModel = BookingModel(
          username: authProvider.userModel.name,
          phoneNumber: phoneNumber,
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

        DateTime selectedDay = DateFormat('dd-MM-yyyy').parse(bookingModel.selectedDay);

        // Check if the appointment is upcoming or completed based on the selected day
        if (isUpcoming && selectedDay.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
          upcomingAppointments.add(bookingModel);
        } else if (!isUpcoming && selectedDay.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
          completedAppointments.add(bookingModel);
        }
      });

      // Now 'appointments' list contains either upcoming or completed appointments
      if (isUpcoming) {
        if (upcomingAppointments.isNotEmpty) {
          showAppointmentListView(upcomingAppointments, 'Upcoming Appointments');
        } else {
          print('No upcoming appointments.');
        }
      } else {
        if (completedAppointments.isNotEmpty) {
          showAppointmentListView(completedAppointments, 'Completed Appointments');
        } else {
          print('No completed appointments.');
        }
      }
    } catch (e) {
      print('Error fetching booking data: $e');
    }
  }



  void storeBookingData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (_selectedTimeSlot.isEmpty) {
      // Show an error message or handle it accordingly
      _showBookingAlertDialog();
    }
    else {
      User? user = _firebaseAuth.currentUser;
      String phoneNumber = user?.phoneNumber ?? '';

      String bookingId = const Uuid().v4();

      BookingModel bookingModel = BookingModel(
        username: authProvider.userModel.name,
        phoneNumber: phoneNumber,
        userId: authProvider.uid,
        selectedDay: DateFormat('dd-MM-yyyy').format(_selectedDay),
        selectedTimeSlot: _selectedTimeSlot,
        hospitalName: widget.hospitalName,
        doctorName: widget.doctorName,
        specialty: widget.specialty,
        hospitalId: widget.hospitalId,
        bookingId: bookingId,
        status: "Pending",
        type: widget.type
      );

        await FirebaseFirestore.instance.collection('bookings').doc(bookingId).set(bookingModel.toMap());
        _showBookingConfirmationDialog();

    }
  }


  void _showBookingAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Please select the time slot first'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ViewBooking()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBookingConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 50,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Success',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text('Your request for appointment has been placed.'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('OK', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void showAppointmentListView(List<BookingModel> appointments, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      BookingModel appointment = appointments[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          subtitle: Text('Day: ${appointment.selectedDay}, \nDoctor: ${appointment.doctorName}, \nSpecialty: ${appointment.specialty} \nTimeSlot: ${appointment.selectedTimeSlot}, \nHospital: ${appointment.hospitalName} \nStatus: ${appointment.status}'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

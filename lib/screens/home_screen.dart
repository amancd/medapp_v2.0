import 'package:flutter/material.dart';
import 'package:medapp/booking/meeting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  // List of grid items
  final List<Map<String, dynamic>> gridItems = [
    {'title': 'Book Appointment', 'icon': Icons.calendar_today, 'widget': const OnlineAppointment()},
    {'title': 'View Bookings', 'icon': Icons.book_online, 'widget': const OnlineAppointment()},
    {'title': 'E-Health Record', 'icon': Icons.health_and_safety, 'widget': const OnlineAppointment()},
    {'title': 'All Hospitals', 'icon': Icons.local_hospital, 'widget': const OnlineAppointment()},
    {'title': 'Emergency', 'icon': Icons.emergency, 'widget': const OnlineAppointment()},
    {'title': 'IOMT', 'icon': Icons.devices, 'widget': const OnlineAppointment()},
    {'title': 'Telemedicine', 'icon': Icons.medical_services, 'widget': const OnlineAppointment()},
    {'title': 'Chat', 'icon': Icons.chat, 'widget': const OnlineAppointment()},
  ];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = gridItems;
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = gridItems;
      } else {
        filteredItems = gridItems
            .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: TextField(
          controller: _searchController,
          onChanged: (query) => _filterItems(query),
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _key.currentState!.openDrawer(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          // Custom Doctor Banner
          _buildDoctorBanner(),

          const SizedBox(height: 10),

          // Grid Layout
          Expanded(child: _buildGridLayout()),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Created with 💖 by CAREMATES"),
          ),
        ],
      ),
      drawer: const Drawer(),
    );
  }

  // Custom doctor banner
  Widget _buildDoctorBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        height: 180,
        child: Stack(
          children: [
            // Doctor image on the right side
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  'assets/doctor.jpg', // Replace with your doctor image asset path
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Text and button on the left side
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Your Health, \nOur Priority",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to booking screen
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OnlineAppointment(),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, // White button background
                      foregroundColor: Colors.deepPurpleAccent, // Purple text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text("Book Appointment"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Grid layout
  Widget _buildGridLayout() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: (screenWidth * 0.85) / 230,
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => item['widget']),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Card(
                color: Colors.transparent, // Make the card background transparent
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 0, // Remove default card elevation
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item['icon'], size: 50, color: Colors.deepPurpleAccent),
                      const SizedBox(height: 10),
                      Text(
                        item['title'],
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

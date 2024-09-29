import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medapp/Navigation/menu.dart';
import 'package:medapp/screens/home_screen.dart';

class IOMT extends StatefulWidget {
  const IOMT({Key? key}) : super(key: key);

  @override
  State<IOMT> createState() => _IOMTState();
}

class _IOMTState extends State<IOMT> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget _buildDeviceButton(String label, IconData icon, Color color) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchingBluetoothScreen(deviceName: label)),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          const SizedBox(width: 8.0),
          Text(label),
        ],
      ),
    );
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
        title: const Text("IOMT", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      drawer: const Navigation(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDeviceButton('Blood Pressure Monitor', Icons.favorite, Colors.deepPurpleAccent),
            const SizedBox(height: 16.0),
            _buildDeviceButton('Blood Glucose Monitor', Icons.trending_up, Colors.deepOrangeAccent),
            const SizedBox(height: 16.0),
            _buildDeviceButton('Pulse Oximeter', Icons.bloodtype, Colors.red),
            const SizedBox(height: 16.0),
            _buildDeviceButton('Fitness Band', Icons.directions_run, Colors.deepPurpleAccent),
          ],
        ),
      ),
    );
  }
}

class SearchingBluetoothScreen extends StatefulWidget {
  final String deviceName;

  const SearchingBluetoothScreen({Key? key, required this.deviceName}) : super(key: key);

  @override
  _SearchingBluetoothScreenState createState() => _SearchingBluetoothScreenState();
}

class _SearchingBluetoothScreenState extends State<SearchingBluetoothScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Simulate searching for Bluetooth devices for 5 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Bluetooth devices found')),
      );

      // Navigate back to the previous screen
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
        title: Text(widget.deviceName, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Searching Bluetooth Device for ${widget.deviceName}'),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

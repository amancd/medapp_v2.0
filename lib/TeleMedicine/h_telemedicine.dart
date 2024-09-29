import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medapp/TeleMedicine/telemedicine.dart';

import '../Navigation/menu.dart';
import '../Pharma/Pharma_home.dart';

class HTeleMedicine extends StatefulWidget {
  const HTeleMedicine({Key? key}) : super(key: key);

  @override
  State<HTeleMedicine> createState() => _HTeleMedicineState();
}

class _HTeleMedicineState extends State<HTeleMedicine> {
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
        title: const Text("TeleMedicine", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PharmaHome()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TeleMedicine()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.medical_services),
                    SizedBox(width: 8),
                    Text('Order Medicine', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveryPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delivery_dining),
                    SizedBox(width: 8),
                    Text('Check Delivery', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveryDetailsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                foregroundColor: Colors.white,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.list_alt),
                    SizedBox(width: 8),
                    Text('Order Details', style: TextStyle(color: Colors.white)),
                  ],
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


class DeliveryDetails {
  final String checkpoints;
  final String deliveryTime;
  final String phoneNumber;
  final String reachedInstructions;
  final String contact;

  DeliveryDetails({
    required this.checkpoints,
    required this.deliveryTime,
    required this.phoneNumber,
    required this.reachedInstructions,
    required this.contact,
  });
}

class DeliveryPage extends StatefulWidget {
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  DeliveryDetails? _deliveryDetails;

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
          title: const Text("Delivery", style: TextStyle(color: Colors.white)),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PharmaHome()),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white),
            ),
          ],
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Your Phone Number:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Fetch and display delivery details
                fetchDeliveryDetails(_phoneNumberController.text.trim());
              },
              child: Text('Fetch Delivery Details', style: TextStyle(color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            if (_deliveryDetails != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Details:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  DeliveryDetailItem(
                    label: 'Checkpoints',
                    value: _deliveryDetails!.checkpoints,
                  ),
                  DeliveryDetailItem(
                    label: 'Delivery Time',
                    value: _deliveryDetails!.deliveryTime,
                  ),
                  DeliveryDetailItem(
                    label: 'Contact Number',
                    value: _deliveryDetails!.contact,
                  ),
                  DeliveryDetailItem(
                    label: 'Reached Instructions',
                    value: _deliveryDetails!.reachedInstructions,
                  ),
                ],
              )
            else
              const Text(
                'No Delivery Details Found!',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
      drawer: const Navigation(),
    );
  }

  Future<void> fetchDeliveryDetails(String phoneNumber) async {
    try {
      // Fetch delivery details based on the phone number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("delivery")
          .where('phoneNumber', isEqualTo: phoneNumber)
          .limit(1) // Assuming each phone number is unique, limit to 1 document
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Extract delivery details from the first document
        DocumentSnapshot doc = querySnapshot.docs.first;
        String checkpoints = doc['checkpoints'] ?? '';
        String deliveryTime = doc['deliveryTime'] ?? '';
        String phoneNumber = doc['phoneNumber'] ?? '';
        String reachedInstructions = doc['reachedInstructions'] ?? '';
        String contact = doc['contact'] ?? '';

        // Update the state with the fetched details
        setState(() {
          _deliveryDetails = DeliveryDetails(
            checkpoints: checkpoints,
            deliveryTime: deliveryTime,
            phoneNumber: phoneNumber,
            reachedInstructions: reachedInstructions,
            contact: contact
          );
        });
      } else {
        // Handle case when no delivery details are found for the given phone number
        print('No delivery details found for phone number: $phoneNumber');
        setState(() {
          _deliveryDetails = null;
        });
      }
    } catch (error) {
      // Handle errors, display an error message, or log the error
      print('Error fetching delivery details: $error');
    }
  }
}

class DeliveryDetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DeliveryDetailItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

class OrderDetails {
  final String address;
  final String city;
  final String email;
  final String fileURL;
  final String medicine;
  final String name;
  final String orderId;
  final String pharmacy;
  final String pharmacyId;
  final String phoneNumber;
  final String state;
  final String status;
  final String uid;

  OrderDetails({
    required this.address,
    required this.city,
    required this.email,
    required this.fileURL,
    required this.medicine,
    required this.name,
    required this.orderId,
    required this.pharmacy,
    required this.pharmacyId,
    required this.phoneNumber,
    required this.state,
    required this.status,
    required this.uid,
  });
}

class DeliveryDetailsScreen extends StatefulWidget {
  @override
  _DeliveryDetailsScreenState createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  OrderDetails? _orderDetails;

  void fetchDeliveryDetails() async {
    String phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isNotEmpty) {
      // Fetch delivery details using the provided phone number
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('telemedicine_requests')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delivery details found
        var deliveryData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          _orderDetails = OrderDetails(
            address: deliveryData['address'],
            city: deliveryData['city'],
            email: deliveryData['email'],
            fileURL: deliveryData['fileURL'],
            medicine: deliveryData['medicine'],
            name: deliveryData['name'],
            orderId: deliveryData['orderId'],
            pharmacy: deliveryData['pharmacy'],
            pharmacyId: deliveryData['pharmacyId'],
            phoneNumber: deliveryData['phoneNumber'],
            state: deliveryData['state'],
            status: deliveryData['status'],
            uid: deliveryData['uid'],
          );
        });
      } else {
        // No delivery details found for the provided phone number
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No Order Details Found.'),
          ),
        );
      }
    } else {
      // Show an error message if the phone number is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter your phone number.'),
        ),
      );
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
        title: const Text("Order Details", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PharmaHome()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Enter your phone number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Fetch and display order details
                fetchDeliveryDetails();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Fetch Order Details',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            _orderDetails != null
                ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Order Details:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text('Address: ${_orderDetails!.address}'),
                Text('City: ${_orderDetails!.city}'),
                Text('Email: ${_orderDetails!.email}'),
                Text('Medicine: ${_orderDetails!.medicine}'),
                Text('Name: ${_orderDetails!.name}'),
                Text('Order ID: ${_orderDetails!.orderId}'),
                Text('Pharmacy: ${_orderDetails!.pharmacy}'),
                Text('Pharmacy ID: ${_orderDetails!.pharmacyId}'),
                Text('Phone Number: ${_orderDetails!.phoneNumber}'),
                Text('State: ${_orderDetails!.state}'),
                Text('Status: ${_orderDetails!.status}'),
              ],
            )
                : const Text('No Order Details Found.'),
          ],
        ),
      ),
      drawer: const Navigation(),
    );
  }
}



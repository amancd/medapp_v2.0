import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medapp/Pharma/Pharma_home.dart';
import 'package:medapp/pharma/pharma_nav.dart';

class DeliveryPage extends StatelessWidget {
  final TextEditingController _phoneNumberController = TextEditingController();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
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
                child: Center(child: Text('Delivery', style: TextStyle(color: Colors.white),))
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PharmaHome(),
                      ),
                    );
                  }, icon: const Icon(Icons.home, color: Colors.white,)),
            ],
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter Customer Phone Number:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_phoneNumberController != null && _phoneNumberController.text.isNotEmpty) {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EnterDeliveryDetails(
                          phoneNumber: _phoneNumberController.text.trim(),
                        ),
                      ),
                    );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Enter Delivery Details', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_phoneNumberController != null && _phoneNumberController.text.isNotEmpty) {
                      Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchDelivery(
                          phoneNumber: _phoneNumberController.text.trim(),
                        ),
                      ),
                    );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Search for Delivery', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const PharmaNav(),
    );
  }
}

class EnterDeliveryDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final String phoneNumber;
  final TextEditingController _deliveryTimeController = TextEditingController();
  final TextEditingController _checkpointsController = TextEditingController();
  final TextEditingController _reachedInstructionsController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EnterDeliveryDetails({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
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
                child: Center(child: Text('Delivery', style: TextStyle(color: Colors.white),))
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PharmaHome(),
                      ),
                    );
                  }, icon: const Icon(Icons.home, color: Colors.white,)),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Phone Number: $phoneNumber',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: _deliveryTimeController,
                  label: 'Delivery Time',
                  hintText: 'Enter delivery time',
                  icon: Icons.access_time,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: _checkpointsController,
                  label: 'Checkpoints',
                  hintText: 'Enter checkpoints',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: _reachedInstructionsController,
                  label: 'Reached Instructions',
                  hintText: 'Enter reached instructions',
                  icon: Icons.note,
                ),
                const SizedBox(height: 16.0),
                _buildInputField(
                  controller: _contactController,
                  label: 'Contact Number',
                  hintText: 'Enter contact number',
                  icon: Icons.call,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Call the function to update delivery details
                    updateDeliveryDetails(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const PharmaNav(),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.deepOrange),
          ),
        ),
      ],
    );
  }

  void updateDeliveryDetails(BuildContext context) async {
    try {
      // Save delivery details to Firestore
      await _firestore.collection('delivery').doc(phoneNumber).set({
        'phoneNumber': phoneNumber,
        'deliveryTime': _deliveryTimeController.text.trim(),
        'checkpoints': _checkpointsController.text.trim(),
        'reachedInstructions': _reachedInstructionsController.text.trim(),
        'contact': _contactController.text.trim(),
        // Add more fields as needed
      });

      // Show success message or navigate back
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Delivery details saved successfully!'),
        duration: Duration(seconds: 2),
      ));

      // You can navigate back to the previous screen or perform any other actions
      Navigator.pop(context);
    } catch (error) {
      // Handle errors, display an error message, or log the error
      print('Error saving delivery details: $error');
    }
  }
}

class SearchDelivery extends StatefulWidget {
  final String phoneNumber;

  const SearchDelivery({required this.phoneNumber});

  @override
  _SearchDeliveryState createState() => _SearchDeliveryState();
}

class _SearchDeliveryState extends State<SearchDelivery> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late DocumentSnapshot _deliverySnapshot;

  @override
  void initState() {
    super.initState();
    fetchDeliveryDetails();
  }

  Future<void> fetchDeliveryDetails() async {
    try {
      // Query Firestore to get the delivery document by phone number
      QuerySnapshot querySnapshot = await _firestore
          .collection('delivery')
          .where('phoneNumber', isEqualTo: widget.phoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          // Store the document snapshot
          _deliverySnapshot = querySnapshot.docs.first;
        });
      }
    } catch (error) {
      // Handle errors, display an error message, or log the error
      print('Error fetching delivery details: $error');
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
                child: Center(child: Text('Search For Delivery', style: TextStyle(color: Colors.white),))
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PharmaHome(),
                      ),
                    );
                  }, icon: const Icon(Icons.home, color: Colors.white,)),
            ],
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_deliverySnapshot != null)
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Details:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16.0),
                      // Display all the fields from the document
                      Text('Phone Number: ${_deliverySnapshot['phoneNumber']}'),
                      Text('Delivery Time: ${_deliverySnapshot['deliveryTime']}'),
                      Text('Checkpoints: ${_deliverySnapshot['checkpoints']}'),
                      Text(
                        'Reached Instructions: ${_deliverySnapshot['reachedInstructions']}',
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the screen to update delivery details
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateDeliveryDetails(
                                documentId: _deliverySnapshot.id,
                                phoneNumber: widget.phoneNumber,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text('Update Delivery Details', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              )
            else
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'No Delivery Details Found!',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('Finish', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
      drawer: const PharmaNav(),
    );
  }
}

class UpdateDeliveryDetails extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  final String documentId;
  final String phoneNumber;
  final TextEditingController _deliveryTimeController = TextEditingController();
  final TextEditingController _checkpointsController = TextEditingController();
  final TextEditingController _reachedInstructionsController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UpdateDeliveryDetails({
    required this.documentId,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Delivery Details'),
      ),
      body: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer Phone Number: $phoneNumber',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Delivery Time:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _deliveryTimeController,
                decoration: const InputDecoration(hintText: 'Enter delivery time'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Checkpoints:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _checkpointsController,
                decoration: const InputDecoration(hintText: 'Enter checkpoints'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Reached Instructions:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _reachedInstructionsController,
                decoration: const InputDecoration(hintText: 'Enter reached instructions'),
              ),
              const Text(
                'Contact Number:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _contactController,
                decoration: const InputDecoration(hintText: 'Enter contact number'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Call the function to update delivery details
                  updateDeliveryDetails();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),

    );
  }

  void updateDeliveryDetails() async {
    try {
      // Update delivery details in Firestore
      await _firestore.collection('delivery').doc(documentId).update({
        'deliveryTime': _deliveryTimeController.text.trim(),
        'checkpoints': _checkpointsController.text.trim(),
        'reachedInstructions': _reachedInstructionsController.text.trim(),
        'contact': _contactController.text.trim()
        // Add more fields as needed
      });

      // Show success message or navigate back

      // You can navigate back to the previous screen or perform any other actions

    } catch (error) {
      // Handle errors, display an error message, or log the error
      print('Error updating delivery details: $error');
    }
  }
}


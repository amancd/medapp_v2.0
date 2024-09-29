import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Navigation/menu.dart';
import 'bookingpage.dart';

class SelectCategory extends StatefulWidget {
  final String type;
  SelectCategory({Key? key, required this.type}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  List<String> _specialties = [];
  String _selectedSpecialty = '';

  @override
  void initState() {
    super.initState();
    _fetchSpecialties();
  }

  Future<void> _fetchSpecialties() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hospitals').get();

      Set<String> specialtiesSet = Set();

      querySnapshot.docs.forEach((hospitalDoc) {
        // Assuming 'doctors' is the subcollection inside each hospital document
        CollectionReference doctorsCollection =
            hospitalDoc.reference.collection('doctors');

        doctorsCollection.get().then((doctorsSnapshot) {
          doctorsSnapshot.docs.forEach((doctorDoc) {
            specialtiesSet.add(doctorDoc['specialty']);
          });

          setState(() {
            _specialties = specialtiesSet.toList();
            if (_selectedSpecialty.isEmpty && _specialties.isNotEmpty) {
              _selectedSpecialty = _specialties[
                  0]; // Set the default value to the first specialty
            }
          });
        });
      });
    } catch (e) {
      print('Error fetching specialties: $e');
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
        title: const Text("Bookings", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: _selectedSpecialty,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSpecialty = newValue!;
                });
              },
              items: _specialties.map((String specialty) {
                return DropdownMenuItem<String>(
                  value: specialty,
                  child: Text(specialty),
                );
              }).toList(),
              hint: const Text('Select Specialty'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_selectedSpecialty.isNotEmpty) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            HospitalListPage(specialty: _selectedSpecialty, type: widget.type)),
                  );
                }
              },
              child: const Text('Proceed to Hospitals'),
            ),
          ],
        ),
      ),
      drawer: const Navigation(),
    );
  }
}

class HospitalListPage extends StatefulWidget {
  final String type;
  final String specialty;

  HospitalListPage({Key? key, required this.specialty, required this.type}) : super(key: key);

  @override
  State<HospitalListPage> createState() => _HospitalListPageState();
}

class _HospitalListPageState extends State<HospitalListPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  int _selectedHospitalIndex = -1;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.deepPurpleAccent,
            child: Center(
              child: Text(
                'Best Hospitals For ${widget.specialty}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: fetchHospitalsBySpecialty(widget.specialty),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Map<String, dynamic>> hospitals =
                      snapshot.data as List<Map<String, dynamic>>;

                  return ListView.builder(
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = hospitals[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(
                              'Hospital Name: ${hospital['name']}',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Doctor Name: ${hospital['doctorName']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Location: ${hospital['location']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Contact: ${hospital['contact']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  'Timings: ${hospital['timings']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                _selectedHospitalIndex = index;
                              });
                              // Navigate to BookingPage with hospital details
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookingPage(
                                    hospitalName: hospital['name'],
                                    doctorName: hospital['doctorName'],
                                    specialty: widget.specialty,
                                    hospitalId: hospital['hospitalId'],
                                    type: widget.type,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
                child: Text(
                    "Please select the hospital in which you want to book")),
          ),
        ],
      ),
      drawer: const Navigation(),
    );
  }

  Future<List<Map<String, dynamic>>> fetchHospitalsBySpecialty(
      String specialty) async {
    try {
      List<Map<String, dynamic>> hospitals = [];

      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('hospitals').get();

      for (QueryDocumentSnapshot hospitalDoc in querySnapshot.docs) {
        // Assuming 'doctors' is the subcollection inside each hospital document
        QuerySnapshot doctorsSnapshot = await hospitalDoc.reference
            .collection('doctors')
            .where('specialty', isEqualTo: specialty)
            .get();

        if (doctorsSnapshot.docs.isNotEmpty) {
          // Add hospital details to the list
          hospitals.add({
            'name': hospitalDoc['name'],
            'location': hospitalDoc['location'],
            'contact': hospitalDoc['contact'],
            'timings': hospitalDoc['timings'],
            'doctorName': doctorsSnapshot.docs[0]['name'],
            'hospitalId': hospitalDoc['hospitalId']
          });
        }
      }

      return hospitals;
    } catch (e) {
      print('Error fetching hospitals by specialty: $e');
      return [];
    }
  }
}

Future<List<String>> fetchHospitalsBySpecialty(String specialty) async {
  try {
    List<String> hospitals = [];

    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('hospitals').get();

    for (QueryDocumentSnapshot hospitalDoc in querySnapshot.docs) {
      // Assuming 'doctors' is the subcollection inside each hospital document
      QuerySnapshot doctorsSnapshot = await hospitalDoc.reference
          .collection('doctors')
          .where('specialty', isEqualTo: specialty)
          .get();

      if (doctorsSnapshot.docs.isNotEmpty) {
        hospitals.add(hospitalDoc['name']);
      }
    }

    return hospitals;
  } catch (e) {
    print('Error fetching hospitals by specialty: $e');
    return [];
  }
}

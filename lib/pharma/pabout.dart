import 'package:flutter/material.dart';
import 'package:medapp/pages/privacy.dart';
import 'package:medapp/pharma/pfeedback.dart';
import 'package:medapp/pharma/pharma_nav.dart';

class PAbout extends StatelessWidget {
  PAbout({Key? key}) : super(key: key);

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
        backgroundColor: Colors.deepOrange,
        title: const Text("About", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PFeedbacks()),
              );
            },
            icon: const Icon(Icons.chat, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.orange,
                  Colors.red
                ],
              )
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Welcome to Hims, your dedicated platform for seamless medical appointment booking and healthcare management. At Hims, we prioritize your well-being by offering a user-friendly and efficient solution to connect with healthcare professionals and schedule appointments at your convenience.", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("HIMS App is powered by Google Dart SDK And Flutter.", style: TextStyle(fontSize: 15, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      drawer: const PharmaNav(),
    );
  }
}

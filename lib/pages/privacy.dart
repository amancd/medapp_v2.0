import 'package:flutter/material.dart';
import '../Navigation/menu.dart';
import '../main.dart';
import 'feedbacks.dart';

class Privacy extends StatelessWidget {
  Privacy({Key? key}) : super(key: key);
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
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const Feedbacks()),
              );
            },
            icon: const Icon(Icons.comment_bank, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), gradient: const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.brown,
                  Colors.brown
                ],
              )
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 15.0, right: 15.0, left: 15.0),
                      child: Text(
                        "Privacy Policy: Hims is committed to protecting the privacy of its users. This policy outlines how we collect, use, and safeguard your personal information.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text(
                        "Information Collection: We may collect personal information, including but not limited to, your name, contact details, and other relevant information, for the purpose of providing personalized services.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 20.0, right: 15.0, left: 15.0),
                      child: Text(
                        "Data Usage: Your personal information may be used to improve our services, personalize your experience, and communicate with you. We do not sell or share your information with third parties without your consent.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ], ),
      drawer: const Navigation(),
    );
  }
}

import 'package:flutter/material.dart';

import '../Navigation/menu.dart';
import '../main.dart';
import 'about.dart';

class Disclaimer extends StatelessWidget {
  Disclaimer({Key? key}) : super(key: key);

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
        title: const Text("Disclaimer", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => About()),
              );
            },
            icon: const Icon(Icons.info_outline, color: Colors.white),
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
                  Colors.pink,
                  Colors.red
                ],
              )
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 15.0, right: 15.0, left: 15.0),
                          child: Text(
                            "Informational Purpose Only: The content provided by the Hims application is for informational purposes only. It is not intended as a substitute for professional medical advice, diagnosis, or treatment.",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            "No Medical Endorsement: Hims does not endorse or recommend any specific tests, physicians, products, procedures, opinions, or other information that may be mentioned in the application. Users are encouraged to seek the advice of qualified healthcare professionals for any medical concerns.",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, bottom: 20.0, right: 15.0, left: 15.0),
                          child: Text(
                            "User Responsibility: Users are solely responsible for decisions made based on the information provided by the Hims application. It is advisable to consult with a qualified healthcare professional before making any medical decisions or changes to existing treatment plans.",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],

                ),
              ),),
          )

        ],
      ),
      drawer: const Navigation(),
    );
  }
}

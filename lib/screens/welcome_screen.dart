import 'package:flutter/material.dart';
import 'package:medapp/hospitals/hospital_login.dart';
import 'package:medapp/provider/auth_provider.dart';
import 'package:medapp/screens/home_screen.dart';
import 'package:medapp/screens/register_screen.dart';
import 'package:medapp/widgets/custom_button.dart';
import 'package:provider/provider.dart';

import '../admin/signform.dart';
import '../pharma/pharma_login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HLoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Hospital Login",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/image1.png",
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Let's get started",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Never a better time than now to start.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInPage(),
                      ),
                    );
                  },
                  child: const Text("Admin Login"),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () async {
                      if (ap.isSignedIn == true) {
                        await ap.getDataFromSP().whenComplete(
                              () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      }
                    },
                    text: "Sign In",
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PSignInPage(),
                      ),
                    );
                  },
                  child: const Text("Pharma Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medapp/admin/admin_home.dart';
import 'package:medapp/hospitals/hospital_home.dart';

class HLoginPage extends StatefulWidget {
  @override
  State<HLoginPage> createState() => _HLoginPageState();
}

class _HLoginPageState extends State<HLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospital Login", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _signIn(context),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.deepPurpleAccent),),
              child: const Text(
                  'Sign In', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),);
  }

  Future<void> _signIn(BuildContext context) async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    try {
      // Use Firebase Authentication to sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>
            HPage()), // Replace HomeScreen with your desired screen
      );
      // Navigate to the next screen or perform other actions upon successful sign-in
    } catch (e) {
      String errorMessage = 'An error occurred';

      if (e is FirebaseAuthException) {
        // Handle specific Firebase Authentication errors
        errorMessage = e.message ?? 'An error occurred';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Login Credentials"),
          duration: Duration(seconds: 3), // Adjust as needed
        ),
      );

      print('Sign-In Error: $e');
    }
  }
}

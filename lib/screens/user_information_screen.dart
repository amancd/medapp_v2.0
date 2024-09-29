import 'package:flutter/material.dart';
import 'package:medapp/model/user_model.dart';
import 'package:medapp/provider/auth_provider.dart';
import 'package:medapp/screens/home_screen.dart';
import 'package:medapp/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class UserInfromationScreen extends StatefulWidget {
  const UserInfromationScreen({super.key});

  @override
  State<UserInfromationScreen> createState() => _UserInfromationScreenState();
}

class _UserInfromationScreenState extends State<UserInfromationScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final bioController = TextEditingController();
  final date = TextEditingController();
  final password = TextEditingController();
  final bloodgroup = TextEditingController();
  final adhaar = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    date.dispose();
    bloodgroup.dispose();
    adhaar.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 25.0, horizontal: 5.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        margin: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            // name field
                            textFeld(
                              hintText: "Enter your name",
                              icon: Icons.account_circle,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              onTap: () => {},
                              controller: nameController,
                            ),

                            // email
                            textFeld(
                              hintText: "Enter your email",
                              icon: Icons.email,
                              inputType: TextInputType.emailAddress,
                              maxLines: 1,
                              onTap: () => {},
                              controller: emailController,
                            ),
                            // bio
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: textFeld(
                                hintText: "Enter your date of birth",
                                icon: Icons.date_range,
                                inputType: TextInputType.text,
                                maxLines: 1,
                                controller: date,
                                onTap: () async {
                                  DateTime? pickeddate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickeddate != null) {
                                    setState(() {
                                      date.text = DateFormat('dd-MM-yyyy').format(pickeddate);
                                    });
                                  }
                                },
                              ),
                            ),

                            textFeld(
                              hintText: "Enter your blood group",
                              icon: Icons.bloodtype,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              onTap: () => {},
                              controller: bloodgroup,
                            ),
                            textFeld(
                              hintText: "Enter your address",
                              icon: Icons.location_on,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              onTap: () => {},
                              controller: bioController,
                            ),
                            textFeld(
                              hintText: "Enter your last 4 digit adhaar",
                              icon: Icons.add_box_rounded,
                              inputType: TextInputType.name,
                              maxLines: 1,
                              onTap: () => {},
                              controller: adhaar,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: CustomButton(
                          text: "Continue",
                          onPressed: () => storeData(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: Colors.purple,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        onTap: onTap,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.purple,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true,
        ),
      ),
    );
  }


  // store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      date: date.text.trim(),
      bio: bioController.text.trim(),
      blood: bloodgroup.text.trim(),
      createdAt: DateTime.now().toString(),
      phoneNumber: "",
      uid: ap.uid,
      adhaar: adhaar.text.trim()
    );
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ),
                          (route) => false),
                    ),
              );
        },
      );
    }
  }

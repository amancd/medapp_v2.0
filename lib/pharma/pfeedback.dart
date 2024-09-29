import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medapp/Pharma/Pharma_home.dart';
import 'package:medapp/pharma/pharma_nav.dart';

class PFeedbacks extends StatefulWidget {
  const PFeedbacks({Key? key}) : super(key: key);

  @override
  State<PFeedbacks> createState() => _PFeedbacksState();
}

class _PFeedbacksState extends State<PFeedbacks> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _key.currentState!.openDrawer();
          },
        ),
        title: const Text("Feedback", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.home, color: Colors.white,),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PharmaHome()),
              );
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange
            ),
            child: const Text('SEND FEEDBACK', style: TextStyle(color: Colors.white)),
            onPressed: () {
              showDialog(
                  context: context, builder:
                  (context) => const FeedbackDialog());
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 15),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), color: Colors.blue),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text("Use this form to share your valuable feedback related to this app with us.", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text("Feel free to share your thoughts, opinions and suggestions with us. We would love to hear from you.", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text("Don't send unnecessary messages or feedback, or please don't do spam!", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(14.0),
                      child: Text("Please mention your name in the feedback.", style: TextStyle(fontSize: 15, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: const PharmaNav(),
    );
  }
}

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({Key? key}) : super(key: key);

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'Enter your feedback here',
            filled: true,
          ),
          maxLines: 5,
          maxLength: 4096,
          textInputAction: TextInputAction.done,
          validator: (String? text) {
            if (text == null || text.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('Send'),
          onPressed: () async {
            // Only if the input form is valid (the user has entered text)
            if (_formKey.currentState!.validate()) {
              // We will use this var to show the result
              // of this operation to the user
              String message;

              try {
                // Get a reference to the `feedback` collection
                final collection =
                FirebaseFirestore.instance.collection('feedback');

                // Write the server's timestamp and the user's feedback
                await collection.doc().set({
                  'timestamp': FieldValue.serverTimestamp(),
                  'feedback': _controller.text,
                });

                message = 'Feedback sent successfully';
              } catch (e) {
                message = 'Error when sending feedback';
              }

              // Show a snackbar with the result
              // ScaffoldMessenger.of(context)
              //     .showSnackBar(SnackBar(content: Text(message)));
              // Navigator.pop(context);
            }
          },
        )
      ],
    );
  }
}

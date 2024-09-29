import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:medapp/ChatSystem/messages.dart';

import '../Navigation/menu.dart';
import '../screens/home_screen.dart';


class UserChatApp extends StatefulWidget {
  @override
  State<UserChatApp> createState() => _UserChatAppState();
}

class _UserChatAppState extends State<UserChatApp> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    super.initState();
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
        title: const Text(
          "Chat With Ved",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: MessagesScreen(messages: messages)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            color: Colors.purpleAccent,
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                    )),
                IconButton(
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send, color: Colors.white,))
              ],
            ),
          )
        ],
      ),
      drawer: const Navigation(),
    );
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: text)));
      if (response.message == null) return;
      setState(() {
        addMessage(response.message!);
      });
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox({Key? key, required this.text, required this.sectionName, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        bottom: 15,
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(sectionName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              IconButton(onPressed: onPressed, icon: const Icon(Icons.edit), color: Colors.yellow)
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final String backText;
  final String title;

  const NavBar({
    Key? key,
    required this.title,
    this.backText = "Trở lại",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15), // Adjust top margin as needed
      child: Row(
        children: [
          if (backText.isNotEmpty) // Conditionally show IconButton if backText is not empty
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          if (backText.isNotEmpty) // Conditionally show Text if backText is not empty
            Text(""),
          Spacer(), // Spacer widget takes remaining space in the Row
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Spacer(), // Another Spacer for balance
        ],
      ),
    );
  }
}

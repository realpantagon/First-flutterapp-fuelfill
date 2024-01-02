import "package:flutter/material.dart";

class car extends StatefulWidget {
  const car({super.key});

  @override
  State<car> createState() => _carState();
}

class _carState extends State<car> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: carbar(),
    );
  }

  AppBar carbar() {
    return AppBar(
      title: Text(
        'Select car',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Color.fromARGB(255, 197, 219, 255),
    );
  }
}

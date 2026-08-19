import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.cyan,
              Colors.pink
            ])
          ),
          child: Center(
            child: Text("Hello World"))),
      ),
    ),
  );
}

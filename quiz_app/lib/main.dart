import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple],
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo-image/logo.png', width: 200),
                  Text(
                    'Learn Flutter the fun way!',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),

                  SizedBox(height: 20),

                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

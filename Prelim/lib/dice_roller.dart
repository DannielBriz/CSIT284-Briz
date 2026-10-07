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
                  Text(
                    'Learn Flutter the fun way!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Quiz started!');
                    },
                    child: Text('Start Quiz'),
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
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      width: 200,
                    'assets/dice-images/dice-2.png'),
                    TextButton(onPressed:() {},
                    child: Text(
                      style:TextStyle,(
                        fontSize: 28
                        )
                      )
                    )
                  ],
                ),
          ),
        ),
      ),
    ),
  );
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_task/screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SplashScreen(),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(width: 0.0, height: 0.0);
      },
    );
  }
}

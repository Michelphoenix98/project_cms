import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        home: Center(
          child: Image(image: AssetImage("assets/logo.png"), height: 100.0),
        ),
      ),
    );
  }
}

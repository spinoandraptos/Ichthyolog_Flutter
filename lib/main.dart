import 'package:flutter/material.dart';
import './Routes/login.dart';
import './Routes/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/signup': (BuildContext context) => SignUpPage()},
      home: const LoginPage(),
    );
  }
}

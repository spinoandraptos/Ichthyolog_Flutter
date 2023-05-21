import 'package:flutter/material.dart';
import './Routes/login.dart';
import './Routes/signup.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

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

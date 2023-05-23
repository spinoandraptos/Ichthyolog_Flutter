import 'package:ichthyolog/main.dart';
import './Http.dart';
import 'package:flutter/material.dart';
import '../Routes/login.dart';

final httpHelpers = HttpHelpers();

class Helpers {
  Future<String> checkJwt() async {
    var jwt = await storage.read(key: "jwt");
    if (jwt != null) {
      return jwt;
    } else {
      return '';
    }
  }

  void logout(String jwt, BuildContext context) async {
    httpHelpers.logoutRequest(jwt).then((response) {
      if (response == 'Logged out') {
        storage.delete(key: 'jwt');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        AlertDialog alert = AlertDialog(
          title: const Text("Notice"),
          content: const Text('Logout failed'),
          actions: [
            TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
        showDialog(
            context: context,
            builder: (context) {
              return alert;
            });
      }
    });
  }
}

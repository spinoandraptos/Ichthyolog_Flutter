import 'package:ichthyolog/main.dart';
import 'http.dart';
import 'package:flutter/material.dart';
import '../Routes/login.dart';
import 'standard_widgets.dart';

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
      if (response == 'Logged out' ||
          response == 'Logged out with expired token') {
        storage.delete(key: 'jwt');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return const NoticeDialog(content: 'Logout failed');
            });
      }
    });
  }
}

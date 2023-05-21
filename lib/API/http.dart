import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ichthyolog/Models/user.dart';

//class which stores the functions responsible for backend communication
class HttpHelpers {
  //signup request returns success message or error message
  //the string can be used for pop-up display etc.
  Future<String> signupRequest(
      String username, String password, String email) async {
    String url = 'http://10.0.2.2:3000/users';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'username': username,
        'password': password,
        'email': email
      }),
    );
    if (response.statusCode == 201) {
      return ('Signup Successful');
    } else {
      return 'Request failed with status: ${response.statusCode}.';
    }
  }

  Future<String> loginRequest(
      String email, String username, String password) async {
    String url = 'http://10.0.2.2:3000/users/login';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'email': email,
        'username': username,
        'password': password
      }),
    );

    debugPrint(response.statusCode.toString());

    if (response.statusCode == 200) {
      return ('Login Successful');
    } else if (response.statusCode == 404) {
      return ('Password Incorrect');
    } else {
      return ('Username Not Found');
    }
  }

  Future<User> viewUserRequest() async {
    String url = 'http://10.0.2.2:3000/users';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return User.fromJson(convert.jsonDecode(response.body));
    } else {
      throw Exception(
          'User not found! Request failed with status: ${response.statusCode}');
    }
  }
}
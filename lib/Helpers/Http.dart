import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ichthyolog/Models/user.dart';
import '../main.dart';

//class which stores the functions responsible for backend communication
class HttpHelpers {
  //signup request returns success message or error message
  //the string can be used for pop-up display etc.
  Future<String> signupRequest(
      String username, String password, String email) async {
    String url = 'http://10.0.2.2:3000/user';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'username': username,
        'password': password,
        'email': email
      }),
    );
    if (response.statusCode == 201) {
      return ('Signup Successful');
    } else {
      return 'Signup failed with status: ${response.statusCode}.';
    }
  }

  Future<String> loginRequest(
      String email, String username, String password) async {
    String url = 'http://10.0.2.2:3000/user/login';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'email': email,
        'username': username,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      return ('Password Incorrect');
    } else {
      return ('Username Not Found');
    }
  }

  Future<String> logoutRequest(String jwt) async {
    String url = 'http://10.0.2.2:3000/user/logout';
    var response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
      'Authorisation': jwt
    });
    if (response.statusCode == 200) {
      debugPrint('HEY');
      return ('Logged out');
    } else {
      return ('Logout failed}');
    }
  }

  Future<User> viewUserRequest(String jwt) async {
    String url = 'http://10.0.2.2:3000/user';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)[0]);
    } else {
      throw Exception('User not found! Error ${response.statusCode}');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:ichthyolog/Routes/login.dart';
import 'login_background.dart';
import '../Helpers/http.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  String _userName = '';
  String _userEmail = '';
  String _password = '';
  String _confirmPassword = '';
  final _formKey = GlobalKey<FormState>();
  final httpHelpers = HttpHelpers();

  bool isValidUsername(String username) {
    if (username.isEmpty || username.length > 25) {
      return false;
    }
    return true;
  }

  void validateForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      httpHelpers
          .signupRequest(_userName, _password, _userEmail)
          .then((String response) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Notice"),
              content: Text(response == 'Signup Successful'
                  ? 'Signup Successful! Please login.'
                  : 'Signup Failed. Please try again.'),
              actions: [
                TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      if (response == 'Signup Successful') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    })
              ],
            );
          },
        );
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^[\w-]+(.[\w-]+)@[a-zA-Z0-9-]+(.[a-zA-Z0-9-]+)(.[a-zA-Z]{2,})$')
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Check if the password meets the criteria
    bool hasCapitalLetter = false;
    bool hasSpecialCharacter = false;

    for (int i = 0; i < password.length; i++) {
      var char = password[i];
      if (char == char.toUpperCase()) {
        hasCapitalLetter = true;
      }
      if (char.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacter = true;
      }
    }

    return hasCapitalLetter && hasSpecialCharacter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const LoginBackgroundPage(),
        ListView(children: [
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //arrow back button to login page
                  Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.only(top: 20),
                    child: IconButton(
                        color: const Color.fromARGB(255, 57, 81, 189),
                        iconSize: 35,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            )),
                  ),

                  //Logo up top
                  Container(
                    width: 170,
                    height: 170,
                    margin: const EdgeInsets.only(top: 10),
                    child: Image.asset('assets/images/Logo.png'),
                  ),

                  //Project name
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Ichthyolog',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),

                  //Username field
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    margin: const EdgeInsets.only(right: 40, left: 40),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        } else if (value.trim().length > 25) {
                          return 'Username must be less than 25 characters';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => _userName = value,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a username',
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Email field
                  Container(
                    margin: const EdgeInsets.only(right: 40, left: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email';
                        } else if (!isValidEmail(value)) {
                          return 'Please enter a valid email';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        _userEmail = value;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your email',
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Password field
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    margin: const EdgeInsets.only(right: 40, left: 40),
                    child: TextFormField(
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 6 || value.length > 20) {
                          return 'Password must be 6-20 characters';
                        } else if (!isValidPassword(value)) {
                          return 'Password must contain at least one capital letter and one special character';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your password',
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Confirm password field
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    margin: const EdgeInsets.only(right: 40, left: 40),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _password) {
                          return 'Passwords do not match';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) => _confirmPassword = value,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Confirm your password',
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Sign up button
                  SizedBox(
                    width: 250,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        validateForm();
                      },
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

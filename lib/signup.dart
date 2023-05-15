import 'package:flutter/material.dart';
import 'login_background.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController1 = TextEditingController();
  final passwordController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const BackgroundPage(),
        Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 170,
                height: 170,
                margin: const EdgeInsets.only(top: 100),
                child: Image.asset('assets/images/Logo.png'),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: const Text(
                  'Ichthyolog',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                margin: const EdgeInsets.only(right: 40, left: 40),
                child: TextField(
                  controller: usernameController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter a username',
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.only(right: 40, left: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email',
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                margin: const EdgeInsets.only(right: 40, left: 40),
                child: TextField(
                  controller: passwordController1,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your password',
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                margin: const EdgeInsets.only(right: 40, left: 40),
                child: TextField(
                  controller: passwordController2,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Confirm your password',
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: implement login functionality
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)))),
                  child: const Text('Sign Up'),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

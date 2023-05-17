import 'package:flutter/material.dart';
import 'login_background.dart';
import 'signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                margin: const EdgeInsets.only(right: 40, left: 40),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white),
                child: TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email or username',
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
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your password',
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 40, left: 40),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: implement reset password functionality
                    },
                    child: const Text('Forgot Password?'),
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
                              borderRadius: BorderRadius.circular(15))),
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 86, 117, 211))),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text('Don\'t have an account?'),
                TextButton(
                  onPressed: () {
                    // TODO: implement sign up functionality
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ]),
            ],
          ),
        ),
      ]),
    );
  }
}

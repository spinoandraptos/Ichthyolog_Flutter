import 'package:flutter/material.dart';
import 'package:ichthyolog/main.dart';
import 'login_background.dart';
import 'signup.dart';
import '../Helpers/helper.dart';
import '../Helpers/Http.dart';
import 'homepage.dart';
import './gallerypage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailUsernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final httpHelpers = HttpHelpers();
  final helpers = Helpers();

  void validateForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      httpHelpers
          .loginRequest(emailUsernameController.text,
              emailUsernameController.text, passwordController.text)
          .then((String response) async {
        Widget continueButton = TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            });

        AlertDialog alert = AlertDialog(
            title: Text("Notice"),
            content: Text(response == 'Password Incorrect'
                ? 'Incorrect password, please try again.'
                : 'Username not found, please try again.'),
            actions: [continueButton]);

        if (response != 'Password Incorrect' &&
            response != 'Username Not Found') {
          await storage.write(key: "jwt", value: response);
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => regularHomePage()),
            );
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              });
        }
      });
    }
  }

  //TODO: add futurebuilder so that this page will not load as long as jwt is
  //still valid (user need not login again)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        const BackgroundPage(),
        ListView(children: [
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //Logo up top
                  Container(
                    width: 170,
                    height: 170,
                    margin: const EdgeInsets.only(top: 100),
                    child: Image.asset('assets/images/Logo.png'),
                  ),

                  //Project name
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

                  //Email field
                  Container(
                    margin: const EdgeInsets.only(right: 40, left: 40),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        return null;
                      },
                      controller: emailUsernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your email or username',
                        contentPadding: EdgeInsets.all(10),
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your password',
                        contentPadding: EdgeInsets.all(15),
                      ),
                    ),
                  ),

                  //Forgot password button
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

                  //Login button
                  Container(
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
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 30),

                  //Sign up button
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Don\'t have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('Sign up'),
                    ),
                  ]),

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GalleryPage()),
                        );
                      },
                      child: const Text('Use this app without an account',
                          style: TextStyle(
                              color: Color.fromARGB(255, 80, 154, 239))),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ]),
      ]),
    );
  }
}

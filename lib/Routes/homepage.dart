import 'package:flutter/material.dart';
import '../Models/user.dart';
import '../main.dart';
import 'dart:convert' as convert;
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import './login.dart';
import 'camerapage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _authorised = false;
  String jwt = '';
  User currUser = User(
      userid: 0,
      username: 'username',
      password: 'password',
      email: 'email',
      profilepic:
          'https://ichthyolog.s3.ap-southeast-1.amazonaws.com/avatar5.png');
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();

  void logout() async {
    httpHelpers.logoutRequest(jwt).then((response) {
      debugPrint('JWT RESPONSE' + response);
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

  @override
  void initState() {
    super.initState();
    helpers.checkJwt().then((token) {
      if (token == '') {
        setState(() {
          _authorised = false;
          jwt = '';
          debugPrint('TOKEN: ' + jwt);
        });
      } else {
        setState(() {
          _authorised = true;
          jwt = token;
          debugPrint('TOKEN: ' + jwt);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_authorised) {
      return AlertDialog(
        title: const Text("Notice"),
        content: const Text('No JWT token'),
        actions: [
          TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              })
        ],
      );
    } else {
      return FutureBuilder<User>(
          future: httpHelpers.viewUserRequest(jwt),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  leading: const Icon(Icons.menu),
                  title: const Text('Home'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        logout();
                      },
                    ),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(snapshot.data!.profilepic),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      snapshot.data!.username,
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: const [
                          Expanded(
                            child: LinearProgressIndicator(
                              value:
                                  0.5, // Replace with the actual progress value
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Level 5', // Replace with the actual level value
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Statistics',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Posts: 0', // Replace with the actual number of posts
                      style: TextStyle(fontSize: 16),
                    ),
                    const Text(
                      'Verifications: 0', // Replace with the actual number of verifications
                      style: TextStyle(fontSize: 16),
                    ),
                    const Text(
                      'Species with Most Posts: ', // Replace with the actual species
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_a_photo_rounded),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CameraPage()),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.post_add),
                        onPressed: () {
                          // Navigate to posts screen
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container(
              color: const Color.fromARGB(255, 236, 249, 255),
              child: const Center(
                child: SizedBox(
                  height: 35.0,
                  width: 35.0,
                  child: CircularProgressIndicator(
                      backgroundColor: Color.fromARGB(255, 91, 170, 255),
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 184, 218, 255)),
                      strokeWidth: 8),
                ),
              ),
            );
          }));
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import '../Helpers/helper.dart';

class HomePage extends StatelessWidget {
  final helpers = Helpers();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: helpers.checkJwt(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == '') {
              return AlertDialog(
                title: Text("Notice"),
                content: Text('No JWT token'),
                actions: [
                  TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      })
                ],
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  leading: Icon(Icons.account_circle_rounded),
                  leadingWidth: 58,
                  title: const Text('Home'),
                  actions: [
                    Icon(Icons.favorite),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.search),
                    ),
                    Icon(Icons.more_vert),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          'https://ichthyolog.s3.ap-southeast-1.amazonaws.com/avatar5.png'),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'User Name',
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
                        onPressed: () {
                          // Navigate to user profile screen
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.camera),
                        onPressed: () {
                          // Navigate to camera screen
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
          }
          return CircularProgressIndicator();
        }));
  }
}
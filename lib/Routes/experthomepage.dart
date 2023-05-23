import 'package:flutter/material.dart';
import '../Models/user.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import 'camerapage.dart';
import './gallerypage.dart';

class expertHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<expertHomePage> {
  bool _authorised = false;
  String jwt = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();

  @override
  void initState() {
    super.initState();
    helpers.checkJwt().then((token) {
      if (token == '') {
        setState(() {
          _authorised = false;
          jwt = '';
        });
      } else {
        setState(() {
          _authorised = true;
          jwt = token;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_authorised) {
      return AlertDialog(
        title: const Text("Notice"),
        content: const Text('Not authorised. Please sign in again'),
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
                  title: const Text('Expert Home'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () {
                        helpers.logout(jwt, context);
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
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: snapshot.data!.level /
                                  100, // Replace with the actual progress value
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Level ${snapshot.data!.level}', // Replace with the actual level value
                            style: const TextStyle(fontSize: 16),
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
                    Text(
                      'Posts: ${snapshot.data!.totalposts}', // Replace with the actual number of posts
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Species Count: ${snapshot.data!.speciescount}', // Replace with the actual number of species found
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Species with Most Posts: ', // Replace with the actual species
                      style: const TextStyle(fontSize: 16),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const GalleryPage()),
                          );
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

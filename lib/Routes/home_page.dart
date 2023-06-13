import 'package:flutter/material.dart';
import '../Helpers/standard_widgets.dart';
import 'gallery_page.dart';
import '../Models/user.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'camera_page.dart';
import 'expert_home_page.dart';
import 'statisticspage.dart';

class RegularHomePage extends StatefulWidget {
  const RegularHomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<RegularHomePage> {
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
      return const NoticeDialog(
          content: 'Not authorised. Please sign in again');
    } else {
      return FutureBuilder<User>(
          future: httpHelpers.viewOwnUserProfileRequest(jwt),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.expert) {
                return const ExpertHomePage();
              } else {
                return Scaffold(
                  appBar: AppBar(
                    leading: const Icon(Icons.menu),
                    title: const Text('Regular Home'),
                    backgroundColor: const Color.fromARGB(255, 70, 88, 152),
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
                      const SizedBox(height: 60),
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        backgroundImage:
                            NetworkImage(snapshot.data!.profilepic),
                      ),
                      const SizedBox(height: 35),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                  builder: (context) => const CameraPage()),
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
                        IconButton(
                          icon: const Icon(Icons.question_mark_outlined),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const StatisticsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return const NoticeDialog(
                  content: 'User not found! Please try again');
            } else {
              return const LoadingScreen();
            }
          }));
    }
  }
}

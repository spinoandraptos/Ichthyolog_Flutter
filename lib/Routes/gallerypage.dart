import 'package:flutter/material.dart';
import 'package:ichthyolog/Models/post.dart';
import 'package:ichthyolog/Routes/postpage.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import '../Routes/homepage.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<Post> postList = [];
  int postCount = 0;
  String jwt = '';
  final httpHelpers = HttpHelpers();
  final helpers = Helpers();

  @override
  void initState() {
    super.initState();
    helpers.checkJwt().then((token) {
      if (token == '') {
        setState(() {
          jwt = '';
        });
      } else {
        setState(() {
          jwt = token;
        });
      }
    });
    httpHelpers.viewAllPostsRequest().then((posts) {
      setState(() {
        for (var everypost in posts) {
          postList.add(everypost);
          postCount += 1;
        }
      });
    });
  }

  Widget galleryScreen(BuildContext context, List<Post> posts) {
    return GridView.builder(
        itemCount: postCount,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 7.0,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          return postCard(posts[index]);
        },
        shrinkWrap: true,
        padding: const EdgeInsets.all(12.0));
  }

  Widget postCard(Post post) {
    return Card(
        color: Color.fromARGB(255, 253, 254, 255),
        elevation: 4.5,
        shadowColor: Color.fromARGB(255, 113, 165, 255),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 9, top: 8),
                  child: Text(
                    post.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8.5,
                        color: Color.fromARGB(255, 33, 53, 88)),
                  )),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: InkWell(
                      child: Ink.image(
                          image: NetworkImage(post.pic), fit: BoxFit.cover),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => regularHomePage()),
                        );
                      }),
                ),
              ),
              Container(
                  padding: EdgeInsets.only(left: 6, bottom: 5, right: 8),
                  child: Text('Sighted at ${post.sightingLocation}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 7,
                          color: Color.fromARGB(255, 33, 53, 88)))),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    if (jwt == '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gallery Page'),
          backgroundColor: Color.fromARGB(255, 51, 64, 113),
        ),
        body: galleryScreen(context, postList),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gallery Page'),
          backgroundColor: Color.fromARGB(255, 70, 88, 152),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                helpers.logout(jwt, context);
              },
            ),
          ],
        ),
        body: galleryScreen(context, postList),
      );
    }
  }
}

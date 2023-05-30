import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ichthyolog/Models/post.dart';
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 7.0,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          return postCard(posts[index]);
        },
        shrinkWrap: true,
        padding: EdgeInsets.all(12.0));
  }

  Widget postCard(Post post) {
    return Card(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: InkWell(
                    child: Ink.image(
                        image: NetworkImage(post.pic),
                        height: 1000,
                        fit: BoxFit.cover),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => regularHomePage()),
                      );
                    }),
              ),
              Center(
                  child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(post.title),
              ))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    if (jwt == '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gallery Page'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gallery Page'),
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

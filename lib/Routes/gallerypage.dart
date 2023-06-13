import 'package:flutter/material.dart';
import 'package:ichthyolog/Models/post.dart';
import 'package:ichthyolog/Routes/postpage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});
  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  String jwt = '';
  Map<String, dynamic> decodedJWT = {};
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
          decodedJWT = JwtDecoder.decode(token);
        });
      }
    });
  }

  Widget galleryScreen(BuildContext context, List<Post> posts) {
    return GridView.builder(
        itemCount: posts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 7.0,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (context, index) {
          if (decodedJWT['username'] == posts[index].authorname) {
            return ownPostCard(posts[index]);
          } else {
            return otherPostCard(posts[index]);
          }
        },
        shrinkWrap: true,
        padding: const EdgeInsets.all(12.0));
  }

  Widget ownPostCard(Post post) {
    return Card(
        color: const Color.fromARGB(255, 253, 254, 255),
        elevation: 4.5,
        shadowColor: const Color.fromARGB(255, 113, 165, 255),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
          Container(
              padding: const EdgeInsets.only(left: 9, top: 8),
              child: Text(
                post.title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 8.5,
                    color: Color.fromARGB(255, 33, 53, 88)),
              )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: InkWell(
                  child: Ink.image(
                      image: NetworkImage(post.pic), fit: BoxFit.cover),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostPage(postid: post.postid)),
                    );
                  }),
            ),
          ),
          Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 4, bottom: 2),
              height: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 40,
                      child: TextButton(
                          style:
                              TextButton.styleFrom(padding: EdgeInsets.all(0)),
                          onPressed: () {},
                          child: const Text('Edit Post',
                              style: TextStyle(
                                  fontSize: 7,
                                  color: Color.fromARGB(255, 33, 53, 88))))),
                  SizedBox(
                      width: 46,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0)),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text("Notice"),
                                      content: const Text(
                                          'Are you sure? This action is irreversible!'),
                                      actions: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 80, 170, 121)),
                                            child: const Text("Yes"),
                                            onPressed: () {
                                              httpHelpers
                                                  .deletePostRequest(
                                                      post.postid, jwt)
                                                  .then(
                                                (response) {
                                                  Navigator.pop(context);
                                                  if (response ==
                                                      'Post Deleted') {
                                                    setState(() {});
                                                    Fluttertoast.showToast(
                                                      msg: 'Post deleted',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                      msg:
                                                          'Post failed to delete :(',
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                    );
                                                  }
                                                },
                                              );
                                            }),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 170, 80, 80)),
                                            child: const Text("Cancel"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            })
                                      ]);
                                });
                          },
                          child: const Text('Delete Post',
                              style: TextStyle(
                                  fontSize: 7,
                                  color: Color.fromARGB(255, 33, 53, 88)))))
                ],
              ))
        ]));
  }

  Widget otherPostCard(Post post) {
    return Card(
        color: const Color.fromARGB(255, 253, 254, 255),
        elevation: 4.5,
        shadowColor: const Color.fromARGB(255, 113, 165, 255),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.only(left: 9, top: 8),
                  child: Text(
                    post.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 8.5,
                        color: Color.fromARGB(255, 33, 53, 88)),
                  )),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: InkWell(
                      child: Ink.image(
                          image: NetworkImage(post.pic), fit: BoxFit.cover),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PostPage(postid: post.postid)),
                        );
                      }),
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 6, bottom: 5, right: 8),
                  child: Text('Sighted at ${post.sightingLocation}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 7,
                          color: Color.fromARGB(255, 33, 53, 88)))),
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewAllVerifiedPostsRequest(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            if (jwt == '') {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Gallery Page'),
                  backgroundColor: const Color.fromARGB(255, 51, 64, 113),
                ),
                body: galleryScreen(context, snapshot.data!),
              );
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Gallery Page'),
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
                body: galleryScreen(context, snapshot.data!),
              );
            }
          } else {
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
          }
        }));
  }
}

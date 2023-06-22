import 'package:flutter/material.dart';
import '../Helpers/standard_widgets.dart';
import '../Models/post.dart';
import 'post_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
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

  Widget logoutButton() {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        helpers.logout(jwt, context);
      },
    );
  }

  Widget galleryLegend() {
    return Padding(
        padding: const EdgeInsets.only(left: 18, top: 10, right: 9),
        child: Row(children: const [
          Text(
            "Key:",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 60, 89, 139)),
          ),
          SizedBox(width: 8),
          CircleAvatar(
              radius: 7,
              backgroundColor: Color.fromARGB(255, 73, 155, 109),
              child: Icon(
                Icons.verified,
                size: 10,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Text(
            "[ ID Verified ]",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color.fromARGB(255, 73, 155, 109)),
          ),
          SizedBox(width: 14),
          CircleAvatar(
              radius: 7,
              backgroundColor: Color.fromARGB(255, 175, 103, 51),
              child: Icon(
                Icons.pending,
                size: 10,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Text(
            "[ Pending Verification ]",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color.fromARGB(255, 175, 103, 51)),
          ),
          SizedBox(width: 14),
          CircleAvatar(
              radius: 7,
              backgroundColor: Color.fromARGB(255, 152, 72, 85),
              child: Icon(
                Icons.priority_high,
                size: 10,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Text(
            "[ Flagged ]",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color.fromARGB(255, 152, 72, 85)),
          ),
        ]));
  }

  Widget galleryScreen(BuildContext context, List<Post> posts) {
    return Column(children: [
      galleryLegend(),
      GridView.builder(
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 7.0,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            if (decodedJWT['username'] == posts[index].authorname) {
              return ownPostCard(posts[index]);
            } else {
              return otherPostCard(posts[index]);
            }
          },
          shrinkWrap: true,
          padding: const EdgeInsets.all(12.0))
    ]);
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
          Padding(
              padding: const EdgeInsets.only(left: 9, top: 5, right: 9),
              child: Row(children: [
                Container(
                    padding: const EdgeInsets.only(right: 4),
                    width: 77,
                    child: Text(
                      post.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                          color: Color.fromARGB(255, 33, 53, 88)),
                    )),
                CircleAvatar(
                  radius: 8,
                  backgroundColor: post.verified
                      ? const Color.fromARGB(255, 73, 155, 109)
                      : post.flagged
                          ? const Color.fromARGB(255, 152, 72, 85)
                          : const Color.fromARGB(255, 175, 103, 51),
                  child: Icon(
                    post.verified
                        ? Icons.verified
                        : post.flagged
                            ? Icons.priority_high
                            : Icons.pending,
                    size: 10,
                    color: Colors.white,
                  ),
                )
              ])),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(3),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: () {},
                      child: const Text('Edit Post',
                          style: TextStyle(
                              fontSize: 7,
                              color: Color.fromARGB(255, 33, 53, 88)))),
                  TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(3),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Text("Warning"),
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
                                              if (response == 'Post Deleted') {
                                                setState(() {});
                                                Fluttertoast.showToast(
                                                  msg: 'Post deleted',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Post failed to delete :(',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
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
                              color: Color.fromARGB(255, 33, 53, 88)))),
                ],
              )),
          Container(
              padding: const EdgeInsets.only(left: 6, bottom: 5, right: 8),
              child: Text('Sighted at ${post.sightingLocation}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 7, color: Color.fromARGB(255, 33, 53, 88)))),
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
              Padding(
                  padding: const EdgeInsets.only(left: 9, top: 5, right: 9),
                  child: Row(children: [
                    Container(
                        padding: const EdgeInsets.only(right: 5),
                        width: 77,
                        child: Text(
                          post.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                              color: Color.fromARGB(255, 33, 53, 88)),
                        )),
                    CircleAvatar(
                      radius: 8,
                      backgroundColor: post.verified
                          ? const Color.fromARGB(255, 73, 155, 109)
                          : post.flagged
                              ? const Color.fromARGB(255, 152, 72, 85)
                              : const Color.fromARGB(255, 175, 103, 51),
                      child: Icon(
                        post.verified
                            ? Icons.verified
                            : post.flagged
                                ? Icons.priority_high
                                : Icons.pending,
                        size: 10,
                        color: Colors.white,
                      ),
                    )
                  ])),
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
        future: httpHelpers.viewAllPostsRequest(),
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
                  actions: [logoutButton()],
                ),
                body: galleryScreen(context, snapshot.data!),
              );
            }
          } else if (snapshot.hasError) {
            return const NoticeDialog(
                content: 'Posts not found! Please try again');
          } else {
            return const LoadingScreen();
          }
        }));
  }
}

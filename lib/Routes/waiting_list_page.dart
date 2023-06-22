import 'package:flutter/material.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import '../Models/post.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'post_page.dart';
import '../Helpers/standard_widgets.dart';

class WaitingListPage extends StatefulWidget {
  const WaitingListPage({super.key});
  @override
  WaitingListPageState createState() => WaitingListPageState();
}

class WaitingListPageState extends State<WaitingListPage> {
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
    return Column(children: [
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
                  backgroundColor: post.flagged
                      ? const Color.fromARGB(255, 152, 72, 85)
                      : const Color.fromARGB(255, 175, 103, 51),
                  child: Icon(
                    post.flagged ? Icons.priority_high : Icons.pending,
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
          Padding(
              padding: const EdgeInsets.only(right: 5, bottom: 6),
              child: Wrap(spacing: 4, alignment: WrapAlignment.end, children: [
                ElevatedButton(
                  onPressed: () {
                    post.flagged
                        ? httpHelpers
                            .unFlagPostRequest(post.postid, jwt)
                            .then((response) {
                            if (response == 'Post Unflagged') {
                              setState(() {});
                              Fluttertoast.showToast(
                                msg: 'Post Unflagged',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Post Unflagging Failed',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          })
                        : httpHelpers
                            .flagPostRequest(post.postid, jwt)
                            .then((response) {
                            if (response == 'Post Flagged') {
                              setState(() {});
                              Fluttertoast.showToast(
                                msg: 'Post Flagged',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Post Flagging Failed',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 5, top: 3, bottom: 3, right: 5),
                      minimumSize: Size.zero,
                      backgroundColor: const Color.fromARGB(255, 170, 80, 80),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: post.flagged
                      ? const Text('Unflag', style: TextStyle(fontSize: 7))
                      : const Text('Flag', style: TextStyle(fontSize: 7)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 5, top: 3, bottom: 3, right: 5),
                      minimumSize: Size.zero,
                      backgroundColor: const Color.fromARGB(255, 80, 106, 170),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Edit', style: TextStyle(fontSize: 7)),
                ),
                ElevatedButton(
                  onPressed: () {
                    httpHelpers
                        .verifyPostRequest(post.postid, jwt)
                        .then((response) {
                      if (response == 'Post Verified') {
                        setState(() {});
                        Fluttertoast.showToast(
                          msg: 'Post Verified',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Post Verification Failed',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 5, top: 3, bottom: 3, right: 5),
                      minimumSize: Size.zero,
                      backgroundColor: const Color.fromARGB(255, 170, 80, 80),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Verify', style: TextStyle(fontSize: 7)),
                )
              ])),
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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                Widget>[
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
                  backgroundColor: post.flagged
                      ? const Color.fromARGB(255, 152, 72, 85)
                      : const Color.fromARGB(255, 175, 103, 51),
                  child: Icon(
                    post.flagged ? Icons.priority_high : Icons.pending,
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
          Padding(
              padding: const EdgeInsets.only(right: 5, bottom: 6),
              child: Wrap(spacing: 4, alignment: WrapAlignment.end, children: [
                ElevatedButton(
                  onPressed: () {
                    post.flagged
                        ? httpHelpers
                            .unFlagPostRequest(post.postid, jwt)
                            .then((response) {
                            if (response == 'Post Unflagged') {
                              setState(() {});
                              Fluttertoast.showToast(
                                msg: 'Post Unflagged',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Post Unflagging Failed',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          })
                        : httpHelpers
                            .flagPostRequest(post.postid, jwt)
                            .then((response) {
                            if (response == 'Post Flagged') {
                              setState(() {});
                              Fluttertoast.showToast(
                                msg: 'Post Flagged',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Post Flagging Failed',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 5, top: 3, bottom: 3, right: 5),
                      minimumSize: Size.zero,
                      backgroundColor: const Color.fromARGB(255, 170, 80, 80),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: post.flagged
                      ? const Text('Unflag', style: TextStyle(fontSize: 7))
                      : const Text('Flag', style: TextStyle(fontSize: 7)),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 5, top: 3, bottom: 3, right: 5),
                      minimumSize: Size.zero,
                      backgroundColor: const Color.fromARGB(255, 80, 106, 170),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Edit', style: TextStyle(fontSize: 7)),
                ),
                ElevatedButton(
                  onPressed: () {
                    httpHelpers
                        .verifyPostRequest(post.postid, jwt)
                        .then((response) {
                      if (response == 'Post Verified') {
                        setState(() {});
                        Fluttertoast.showToast(
                          msg: 'Post Verified',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Post Verification Failed',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 5, top: 3, bottom: 3, right: 5),
                      minimumSize: Size.zero,
                      backgroundColor: const Color.fromARGB(255, 170, 80, 80),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: const Text('Verify', style: TextStyle(fontSize: 7)),
                )
              ]))
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewAllUnverifiedPostsRequest(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Pending ID Waiting List'),
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
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const NoticeDialog(
                content: 'Posts not found! Please try again');
          } else {
            return const LoadingScreen();
          }
        }));
  }

  Widget galleryLegend() {
    return const Padding(
        padding: EdgeInsets.only(left: 18, top: 10, right: 9),
        child: Row(children: [
          Text(
            "Key:",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 60, 89, 139)),
          ),
          SizedBox(width: 8),
          CircleAvatar(
              radius: 8,
              backgroundColor: Color.fromARGB(255, 73, 155, 109),
              child: Icon(
                Icons.verified,
                size: 10,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Text(
            "[ Verified Post ]",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color.fromARGB(255, 73, 155, 109)),
          ),
          SizedBox(width: 14),
          CircleAvatar(
              radius: 8,
              backgroundColor: Color.fromARGB(255, 152, 72, 85),
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
                fontSize: 12,
                color: Color.fromARGB(255, 152, 72, 85)),
          ),
        ]));
  }
}

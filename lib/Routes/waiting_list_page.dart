import 'package:flutter/material.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import '../Models/post.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'post_page.dart';
import '../Helpers/standard_widgets.dart';
import 'stepper.dart';

class WaitingListPage extends StatefulWidget {
  const WaitingListPage({super.key});
  @override
  WaitingListPageState createState() => WaitingListPageState();
}

class WaitingListPageState extends State<WaitingListPage> {
  String jwt = '';
  Map<String, dynamic> decodedJWT = {};
  String newTitle = '';
  String newDescription = '';
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
    return SingleChildScrollView(
        child: SizedBox(
            child: Column(children: [
      galleryLegend(),
      GridView.builder(
          itemCount: posts.length,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
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
    ])));
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
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 9, top: 5, right: 9),
                  child: Row(children: [
                    Container(
                        padding: const EdgeInsets.only(right: 4),
                        width: MediaQuery.of(context).size.width * 1 / 2.85,
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
              clickableImage(post),
              expertActions(post)
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
                        width: MediaQuery.of(context).size.width * 1 / 2.85,
                        child: Text(
                          post.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
              clickableImage(post),
              expertActions(post)
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
                backgroundColor: const Color.fromARGB(255, 65, 90, 181),
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

  Widget clickableImage(Post post) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
            child: Ink.image(image: NetworkImage(post.pic), fit: BoxFit.cover),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostPage(postid: post.postid)),
              );
            }),
      ),
    );
  }

  Widget expertActions(Post post) {
    return Padding(
        padding: const EdgeInsets.only(right: 7, bottom: 8, top: 3),
        child: Wrap(spacing: 4, alignment: WrapAlignment.end, children: [
          flagPostButton(post),
          editPostButton(post),
          verifyPostButton(post),
          deletePostButton(post)
        ]));
  }

  Widget flagPostButton(Post post) {
    return ElevatedButton(
      onPressed: () {
        post.flagged
            ? httpHelpers.unFlagPostRequest(post.postid, jwt).then((response) {
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
            : httpHelpers.flagPostRequest(post.postid, jwt).then((response) {
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
          padding: const EdgeInsets.only(left: 5, top: 3, bottom: 3, right: 5),
          minimumSize: Size.zero,
          backgroundColor: const Color.fromARGB(255, 170, 80, 80),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: post.flagged
          ? const Text('Unflag', style: TextStyle(fontSize: 10))
          : const Text('Flag', style: TextStyle(fontSize: 10)),
    );
  }

  Widget editPostButton(Post post) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              String newClass = '';
              String newOrder = '';
              String newFamily = '';
              String newGenus = '';

              return StatefulBuilder(builder: (context, setState) {
                classCallback(newValue) {
                  setState(() {
                    newClass = newValue;
                  });
                  print(newClass);
                }

                orderCallback(newValue) {
                  setState(() {
                    newOrder = newValue;
                  });
                  print(newOrder);
                }

                familyCallback(newValue) {
                  setState(() {
                    newFamily = newValue;
                  });
                  print(newFamily);
                }

                genusCallback(newValue) {
                  setState(() {
                    newGenus = newValue;
                  });
                  print(newGenus);
                }

                return AlertDialog(
                  title: const Text("Edit Post"),
                  content: SingleChildScrollView(
                      child: Column(children: [
                    Container(
                        margin: const EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Edit Title',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        initialValue: post.title,
                        decoration: const InputDecoration(
                          hintText: 'Edit Title',
                        ),
                        onChanged: (value) {
                          setState(() {
                            newTitle = value;
                          });
                        },
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 20, left: 15),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Edit Description',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        child: TextFormField(
                          initialValue: post.description,
                          minLines: 1,
                          maxLines: 8,
                          decoration: const InputDecoration(
                              hintText: 'Edit Description'),
                          onChanged: (value) {
                            setState(() {
                              newDescription = value;
                            });
                          },
                        )),
                    Wrap(
                      children: [
                        const Text(
                          'Class: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113),
                              fontSize: 12),
                        ),
                        Text(
                          newClass == '' ? '${post.class_}   ' : '$newClass   ',
                          style: const TextStyle(fontSize: 11),
                        ),
                        const Text(
                          'Order: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113),
                              fontSize: 12),
                        ),
                        Text(
                          newOrder == '' ? '${post.order}' : newOrder,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        const Text(
                          'Family: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113),
                              fontSize: 12),
                        ),
                        Text(
                          newFamily == ''
                              ? '${post.family}   '
                              : '$newFamily   ',
                          style: const TextStyle(fontSize: 11),
                        ),
                        const Text(
                          'Genus: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113),
                              fontSize: 12),
                        ),
                        Text(
                          newGenus == '' ? '${post.genus}' : newGenus,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  ])),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: StatefulBuilder(
                                builder: (context, setState) {
                                  return SpeciesStepper(
                                    classCallback: classCallback,
                                    orderCallback: orderCallback,
                                    familyCallback: familyCallback,
                                    genusCallback: genusCallback,
                                  );
                                },
                              ));
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 102, 154, 217)),
                      child: const Text(
                        'Edit Classification',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 80, 170, 121)),
                        child: const Text("Confirm",
                            style: TextStyle(fontSize: 12)),
                        onPressed: () {
                          httpHelpers
                              .editPostInfoRequest(
                                  post.postid,
                                  jwt,
                                  newTitle,
                                  newDescription,
                                  newClass,
                                  newOrder,
                                  newFamily,
                                  newGenus)
                              .then((response) {
                            if (response == 'Post Edited') {
                              Navigator.pop(context);
                              setState(() {
                                newClass = '';
                                newOrder = '';
                                newFamily = '';
                                newGenus = '';
                              });
                              Fluttertoast.showToast(
                                msg: 'Post Edited',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Post Edit Failed :(',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          });
                        }),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 170, 80, 80)),
                        child: const Text("Cancel",
                            style: TextStyle(fontSize: 12)),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            newClass = '';
                            newOrder = '';
                            newFamily = '';
                            newGenus = '';
                          });
                        })
                  ],
                );
              });
            });
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(left: 5, top: 3, bottom: 3, right: 5),
          minimumSize: Size.zero,
          backgroundColor: const Color.fromARGB(255, 80, 106, 170),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: const Text('Edit', style: TextStyle(fontSize: 10)),
    );
  }

  Widget verifyPostButton(Post post) {
    return ElevatedButton(
      onPressed: () {
        httpHelpers.verifyPostRequest(post.postid, jwt).then((response) {
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
          padding: const EdgeInsets.only(left: 5, top: 3, bottom: 3, right: 5),
          minimumSize: Size.zero,
          backgroundColor: Color.fromARGB(255, 59, 132, 91),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: const Text('Verify', style: TextStyle(fontSize: 10)),
    );
  }

  Widget deletePostButton(Post post) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text("Warning"),
                  content:
                      const Text('Are you sure? This action is irreversible!'),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 80, 170, 121)),
                        child: const Text("Yes"),
                        onPressed: () {
                          httpHelpers.deletePostRequest(post.postid, jwt).then(
                            (response) {
                              Navigator.pop(context);
                              if (response == 'Post Deleted') {
                                setState(() {});
                                Fluttertoast.showToast(
                                  msg: 'Post deleted',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Post failed to delete :(',
                                  toastLength: Toast.LENGTH_SHORT,
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
                                const Color.fromARGB(255, 170, 80, 80)),
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]);
            });
      },
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(left: 5, top: 3, bottom: 3, right: 5),
          minimumSize: Size.zero,
          backgroundColor: Color.fromARGB(255, 189, 104, 20),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: const Text('Delete', style: TextStyle(fontSize: 10)),
    );
  }
}

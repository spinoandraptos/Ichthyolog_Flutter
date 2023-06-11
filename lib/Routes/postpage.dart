import 'package:flutter/material.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'commentspage.dart';

class PostPage extends StatefulWidget {
  final int postid;
  const PostPage({Key? key, required this.postid}) : super(key: key);
  @override
  PostPageState createState() => PostPageState(postid);
}

class PostPageState extends State<PostPage> {
  String jwt = '';
  int _postid = 0;
  final contentText = TextEditingController();

  final httpHelpers = HttpHelpers();
  final helpers = Helpers();
  PostPageState(int postid) {
    _postid = postid;
  }

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
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    contentText.dispose();
    contentText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewPostRequest(_postid),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data!.title),
                backgroundColor: const Color.fromARGB(255, 51, 64, 113),
              ),
              body: SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 1.2,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 6, bottom: 8),
                              child: ListTile(
                                visualDensity:
                                    VisualDensity(horizontal: 0, vertical: -4),
                                leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(snapshot.data!.authorpic)),
                                title: Text(
                                  snapshot.data!.authorname,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 51, 64, 113)),
                                ),
                                subtitle: Text(
                                    'Sighted at ${snapshot.data!.sightingLocation} at ${snapshot.data!.sightingTime} '),
                              )),
                          ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 350,
                                minWidth: MediaQuery.of(context).size.width,
                                maxWidth: MediaQuery.of(context).size.width,
                              ),
                              child: FittedBox(
                                  clipBehavior: Clip.hardEdge,
                                  fit: BoxFit.cover,
                                  child: Image(
                                    image: NetworkImage(snapshot.data!.pic),
                                  ))),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 15),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )),
                          Container(
                              padding: const EdgeInsets.only(
                                  left: 20, top: 5, right: 20, bottom: 5),
                              alignment: Alignment.centerLeft,
                              child: Text(snapshot.data!.description)),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(
                                      left: 20, top: 18, bottom: 12),
                                  child: const Text(
                                    "Comments",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 51, 64, 113)),
                                  ),
                                ),
                                FutureBuilder(
                                  future: httpHelpers
                                      .viewPostCommentsRequest(_postid),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData &&
                                        snapshot.data!.length > 1) {
                                      return Column(children: [
                                        ListTile(
                                          horizontalTitleGap: 10,
                                          contentPadding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          leading: CircleAvatar(
                                              radius: 18,
                                              backgroundImage: NetworkImage(
                                                  snapshot
                                                      .data![snapshot
                                                              .data!.length -
                                                          1]
                                                      .authorPic)),
                                          title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 3),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 2),
                                                        child: Text(
                                                          snapshot
                                                              .data![snapshot
                                                                      .data!
                                                                      .length -
                                                                  1]
                                                              .authorName,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          51,
                                                                          64,
                                                                          113)),
                                                        )),
                                                    Text(snapshot
                                                        .data![snapshot
                                                                .data!.length -
                                                            1]
                                                        .content)
                                                  ])),
                                          subtitle: Text(
                                            'Posted at ${snapshot.data![snapshot.data!.length - 1].postedTime}',
                                            style:
                                                const TextStyle(fontSize: 11),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CommentPage(
                                                          postid: _postid)),
                                            );
                                          },
                                          child: Text(
                                            'View ${snapshot.data!.length - 1} other replies',
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 51, 64, 113)),
                                          ),
                                        ),
                                      ]);
                                    } else if (snapshot.hasData &&
                                        snapshot.data!.length == 1) {
                                      return jwt == ''
                                          ? ListTile(
                                              horizontalTitleGap: 10,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20, right: 20),
                                              leading: CircleAvatar(
                                                  radius: 18,
                                                  backgroundImage: NetworkImage(
                                                      snapshot
                                                          .data![snapshot.data!
                                                                  .length -
                                                              1]
                                                          .authorPic)),
                                              title: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 3),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 2),
                                                            child: Text(
                                                              snapshot
                                                                  .data![snapshot
                                                                          .data!
                                                                          .length -
                                                                      1]
                                                                  .authorName,
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          51,
                                                                          64,
                                                                          113)),
                                                            )),
                                                        Text(snapshot
                                                            .data![snapshot
                                                                    .data!
                                                                    .length -
                                                                1]
                                                            .content)
                                                      ])),
                                              subtitle: Text(
                                                'Posted at ${snapshot.data![snapshot.data!.length - 1].postedTime}',
                                                style: const TextStyle(
                                                    fontSize: 11),
                                              ),
                                            )
                                          : Column(children: [
                                              ListTile(
                                                horizontalTitleGap: 10,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 20, right: 20),
                                                leading: CircleAvatar(
                                                    radius: 18,
                                                    backgroundImage:
                                                        NetworkImage(snapshot
                                                            .data![snapshot
                                                                    .data!
                                                                    .length -
                                                                1]
                                                            .authorPic)),
                                                title: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 3),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          2),
                                                              child: Text(
                                                                snapshot
                                                                    .data![snapshot
                                                                            .data!
                                                                            .length -
                                                                        1]
                                                                    .authorName,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            51,
                                                                            64,
                                                                            113)),
                                                              )),
                                                          Text(snapshot
                                                              .data![snapshot
                                                                      .data!
                                                                      .length -
                                                                  1]
                                                              .content)
                                                        ])),
                                                subtitle: Text(
                                                  'Posted at ${snapshot.data![snapshot.data!.length - 1].postedTime}',
                                                  style: const TextStyle(
                                                      fontSize: 11),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  controller: contentText,
                                                  decoration: InputDecoration(
                                                    hintText: 'Reply',
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          contentText.clear();
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.clear),
                                                    ),
                                                  ),
                                                  onFieldSubmitted: (value) {
                                                    setState(() {
                                                      contentText.text = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  margin: const EdgeInsets.only(
                                                      top: 6,
                                                      right: 20,
                                                      bottom: 10),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      httpHelpers
                                                          .addCommentRequest(
                                                              _postid,
                                                              contentText.text,
                                                              jwt)
                                                          .then((response) {
                                                        if (response ==
                                                            'Comment Posted') {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Comment posted successfully!',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                          setState(() {
                                                            contentText.clear();
                                                          });
                                                        } else {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Comment failed to post :(',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                        }
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    68,
                                                                    86,
                                                                    148)),
                                                    child: const Text('Post',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  )),
                                            ]);
                                    } else {
                                      return jwt == ''
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 5),
                                              alignment: Alignment.centerLeft,
                                              child:
                                                  const Text('No comments yet'))
                                          : Column(children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          bottom: 5),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: const Text(
                                                      'No comments yet')),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5,
                                                    left: 20,
                                                    right: 20),
                                                child: TextFormField(
                                                  controller: contentText,
                                                  decoration: InputDecoration(
                                                    hintText: 'Reply',
                                                    suffixIcon: IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          contentText.clear();
                                                        });
                                                      },
                                                      icon: const Icon(
                                                          Icons.clear),
                                                    ),
                                                  ),
                                                  onFieldSubmitted: (value) {
                                                    setState(() {
                                                      contentText.text = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  margin: const EdgeInsets.only(
                                                      top: 6,
                                                      right: 20,
                                                      bottom: 10),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      httpHelpers
                                                          .addCommentRequest(
                                                              _postid,
                                                              contentText.text,
                                                              jwt)
                                                          .then((response) {
                                                        if (response ==
                                                            'Comment Posted') {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Comment posted successfully!',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                          setState(() {
                                                            contentText.clear();
                                                          });
                                                        } else {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Comment failed to post :(',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                        }
                                                      });
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    68,
                                                                    86,
                                                                    148)),
                                                    child: const Text('Post',
                                                        style: TextStyle(
                                                            fontSize: 15)),
                                                  )),
                                            ]);
                                    }
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ))),
            );
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

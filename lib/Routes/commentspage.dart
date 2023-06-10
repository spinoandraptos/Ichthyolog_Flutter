import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';

class CommentPage extends StatefulWidget {
  final int postid;
  const CommentPage({Key? key, required this.postid}) : super(key: key);
  @override
  CommentPageState createState() => CommentPageState(postid);
}

class CommentPageState extends State<CommentPage> {
  String jwt = '';
  int _postid = 0;
  final contentText = TextEditingController();

  final httpHelpers = HttpHelpers();
  final helpers = Helpers();
  CommentPageState(int postid) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewPostCommentsRequest(_postid),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return jwt == ''
                ? Scaffold(
                    appBar: AppBar(
                      title: const Text('Comments'),
                      backgroundColor: const Color.fromARGB(255, 51, 64, 113),
                    ),
                    body: SingleChildScrollView(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: [
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: ListTile(
                                            horizontalTitleGap: 10,
                                            contentPadding:
                                                const EdgeInsets.only(
                                                    left: 20, right: 20),
                                            leading: CircleAvatar(
                                                radius: 18,
                                                backgroundImage: NetworkImage(
                                                    snapshot.data![index]
                                                        .authorPic)),
                                            title: Padding(
                                                padding: const EdgeInsets.only(
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
                                                                .data![index]
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
                                                          .data![index].content)
                                                    ])),
                                            subtitle: Text(
                                              'Posted at ${snapshot.data![index].postedTime}',
                                              style:
                                                  const TextStyle(fontSize: 11),
                                            ),
                                          ));
                                    },
                                  ))
                            ]))))
                : Scaffold(
                    appBar: AppBar(
                      title: const Text('Comments'),
                      backgroundColor: const Color.fromARGB(255, 51, 64, 113),
                    ),
                    body: SingleChildScrollView(
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                    height: snapshot.data!.length <= 8
                                        ? MediaQuery.of(context).size.height *
                                            snapshot.data!.length *
                                            1 /
                                            11
                                        : MediaQuery.of(context).size.height *
                                            4.35 /
                                            6,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, right: 5),
                                            child: ListTile(
                                              horizontalTitleGap: 10,
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 20, right: 20),
                                              leading: CircleAvatar(
                                                  radius: 18,
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data![index]
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
                                                                  .data![index]
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
                                                            .data![index]
                                                            .content)
                                                      ])),
                                              subtitle: Text(
                                                'Posted at ${snapshot.data![index].postedTime}',
                                                style: const TextStyle(
                                                    fontSize: 11),
                                              ),
                                            ));
                                      },
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, left: 25, right: 25),
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
                                        icon: const Icon(Icons.clear),
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
                                    alignment: Alignment.centerRight,
                                    margin: const EdgeInsets.only(
                                        top: 6, right: 25, bottom: 10),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        httpHelpers
                                            .addCommentRequest(
                                                _postid, contentText.text, jwt)
                                            .then((response) {
                                          if (response == 'Comment Posted') {
                                            Fluttertoast.showToast(
                                              msg:
                                                  'Comment posted successfully!',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                            );
                                            setState(() {
                                              contentText.clear();
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: 'Comment failed to post :(',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                            );
                                          }
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 68, 86, 148)),
                                      child: const Text('Post',
                                          style: TextStyle(fontSize: 15)),
                                    )),
                              ],
                            ))));
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

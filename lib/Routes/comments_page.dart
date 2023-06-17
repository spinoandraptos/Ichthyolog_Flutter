import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Helpers/standard_widgets.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'comments.dart';

class CommentPage extends StatefulWidget {
  final int postid;
  const CommentPage({Key? key, required this.postid}) : super(key: key);
  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  String jwt = '';
  Map<String, dynamic> decodedJWT = {};
  final contentText = TextEditingController();

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

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    contentText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewPostCommentsRequest(widget.postid),
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
                                      return OtherComment(
                                          comment: snapshot.data![index],
                                          jwt: jwt,
                                          updateCallBack:
                                              updateCommentCallback);
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
                                Container(
                                    padding: const EdgeInsets.only(top: 6),
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height -
                                              210,
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        if (snapshot.data![index].authorName ==
                                            decodedJWT['username']) {
                                          return OwnComment(
                                            comment: snapshot.data![index],
                                            jwt: jwt,
                                            updateCallBack:
                                                updateCommentCallback,
                                          );
                                        } else {
                                          return OtherComment(
                                              comment: snapshot.data![index],
                                              jwt: jwt,
                                              updateCallBack:
                                                  updateCommentCallback);
                                        }
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
                                            .addCommentRequest(widget.postid,
                                                contentText.text, jwt)
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
          } else if (snapshot.hasError) {
            return const NoticeDialog(
                content: 'Comments not found! Please try again');
          } else {
            return const LoadingScreen();
          }
        }));
  }

  updateCommentCallback(response) {
    if (response == 'Comment Deleted' ||
        response == 'Comment Upvoted' ||
        response == 'Comment Downvoted') {
      setState(() {});
    }
  }
}

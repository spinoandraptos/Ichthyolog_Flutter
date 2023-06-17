import 'package:flutter/material.dart';
import '../Models/comment.dart';
import '../Helpers/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OwnComment extends StatefulWidget {
  final Comment comment;
  final String jwt;
  final Function updateCallBack;
  const OwnComment(
      {Key? key,
      required this.comment,
      required this.jwt,
      required this.updateCallBack})
      : super(key: key);

  @override
  OwnCommentState createState() => OwnCommentState();
}

class OwnCommentState extends State<OwnComment> {
  final httpHelpers = HttpHelpers();
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ListTile(
              horizontalTitleGap: 10,
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              leading: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(widget.comment.authorPic)),
              title: Padding(
                  padding: const EdgeInsets.only(bottom: 3),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              widget.comment.authorName,
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 51, 64, 113)),
                            )),
                        Text(widget.comment.content)
                      ])),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Posted at ${widget.comment.postedTime}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    Container(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  httpHelpers
                                      .upVoteCommentRequest(
                                          widget.comment.commentId, widget.jwt)
                                      .then((response) {
                                    if (response == 'Comment Upvoted') {
                                      widget.updateCallBack(response);
                                      Fluttertoast.showToast(
                                        msg: 'Comment Upvoted',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: 'Comment failed to upvote :(',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                      );
                                    }
                                  });
                                },
                                icon: const Icon(Icons.update)),
                            IconButton(
                                onPressed: () {
                                  httpHelpers
                                      .downVoteCommentRequest(
                                          widget.comment.commentId, widget.jwt)
                                      .then((response) {
                                    if (response == 'Comment Downvoted') {
                                      widget.updateCallBack(response);
                                      Fluttertoast.showToast(
                                        msg: 'Comment Downvoted',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: 'Comment failed to Downvote :(',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                      );
                                    }
                                  });
                                },
                                icon: const Icon(Icons.update)),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(3),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
                                onPressed: () {},
                                child: const Text('Edit Comment',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            Color.fromARGB(255, 68, 95, 143)))),
                            TextButton(
                                style: TextButton.styleFrom(
                                    padding: const EdgeInsets.all(3),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap),
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  80,
                                                                  170,
                                                                  121)),
                                                  child: const Text("Yes"),
                                                  onPressed: () {
                                                    httpHelpers
                                                        .deleteCommentRequest(
                                                            widget.comment
                                                                .commentId,
                                                            widget.jwt)
                                                        .then(
                                                      (response) {
                                                        Navigator.pop(context);
                                                        if (response ==
                                                            'Comment Deleted') {
                                                          widget.updateCallBack(
                                                              response);
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Comment deleted',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                        } else {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg:
                                                                'Comment failed to delete :(',
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                        }
                                                      },
                                                    );
                                                  }),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  170,
                                                                  80,
                                                                  80)),
                                                  child: const Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  })
                                            ]);
                                      });
                                },
                                child: const Text('Delete Comment',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color:
                                            Color.fromARGB(255, 68, 95, 143)))),
                          ],
                        )),
                  ]))),
    ]);
  }
}

class OtherComment extends StatefulWidget {
  final Comment comment;
  final String jwt;
  final Function updateCallBack;
  const OtherComment(
      {Key? key,
      required this.comment,
      required this.jwt,
      required this.updateCallBack})
      : super(key: key);

  @override
  OtherCommentState createState() => OtherCommentState();
}

class OtherCommentState extends State<OtherComment> {
  final httpHelpers = HttpHelpers();
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ListTile(
          horizontalTitleGap: 10,
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
          leading: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.comment.authorPic)),
          title: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          widget.comment.authorName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        )),
                    Text(widget.comment.content)
                  ])),
          subtitle: Text(
            'Posted at ${widget.comment.postedTime}',
            style: const TextStyle(fontSize: 11),
          ),
          trailing: IconButton(
              iconSize: 20,
              onPressed: () {
                httpHelpers
                    .upVoteCommentRequest(widget.comment.commentId, widget.jwt)
                    .then((response) {
                  if (response == 'Comment Upvoted') {
                    widget.updateCallBack(response);
                    Fluttertoast.showToast(
                      msg: 'Comment Upvoted',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Comment failed to upvote :(',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                    );
                  }
                });
              },
              icon: const Icon(Icons.update)),
        ));
  }
}

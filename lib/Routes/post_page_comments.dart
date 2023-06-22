import 'package:flutter/material.dart';
import '../Models/comment.dart';
import '../Helpers/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'comments_page.dart';
import 'comments.dart';

class PostPageMultiComment extends StatelessWidget {
  final List<Comment> comments;
  final httpHelpers = HttpHelpers();
  final String jwt;
  final int postid;
  PostPageMultiComment(
      {Key? key,
      required this.comments,
      required this.jwt,
      required this.postid})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        leading: CircleAvatar(
            radius: 18,
            backgroundImage:
                NetworkImage(comments[comments.length - 1].authorPic)),
        title: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    comments[comments.length - 1].authorName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 51, 64, 113)),
                  )),
              Text(comments[comments.length - 1].content)
            ])),
        subtitle: Text(
          'Posted at ${comments[comments.length - 1].postedTime}',
          style: const TextStyle(fontSize: 11),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CommentPage(postid: postid)),
          );
        },
        child: Text(
          'View ${comments.length - 1} other replies',
          style: const TextStyle(color: Color.fromARGB(255, 51, 64, 113)),
        ),
      ),
    ]);
  }
}

class PostPageSingleComment extends StatefulWidget {
  final List<Comment> comments;
  final String jwt;

  final int postid;
  final Map<String, dynamic> decodedJWT;
  final Function updateCallBack;

  const PostPageSingleComment(
      {Key? key,
      required this.comments,
      required this.jwt,
      required this.postid,
      required this.decodedJWT,
      required this.updateCallBack})
      : super(key: key);

  @override
  PostPageSingleCommentState createState() => PostPageSingleCommentState();
}

class PostPageSingleCommentState extends State<PostPageSingleComment> {
  final contentText = TextEditingController();
  final httpHelpers = HttpHelpers();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    contentText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.jwt == ''
        ? Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: OtherComment(
                comment: widget.comments[widget.comments.length - 1],
                jwt: widget.jwt,
                updateCallBack: widget.updateCallBack,
                userid: widget.decodedJWT['userid'] ?? -1))
        : Column(children: [
            widget.comments[widget.comments.length - 1].authorId ==
                    widget.decodedJWT['userid']
                ? OwnComment(
                    comment: widget.comments[widget.comments.length - 1],
                    jwt: widget.jwt,
                    updateCallBack: widget.updateCallBack,
                    userid: widget.decodedJWT['userid'])
                : OtherComment(
                    comment: widget.comments[widget.comments.length - 1],
                    jwt: widget.jwt,
                    updateCallBack: widget.updateCallBack,
                    userid: widget.decodedJWT['userid']),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
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
                margin: const EdgeInsets.only(top: 6, right: 20, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    httpHelpers
                        .addCommentRequest(
                            widget.postid, contentText.text, widget.jwt)
                        .then((response) {
                      if (response == 'Comment Posted') {
                        widget.updateCallBack(response);
                        Fluttertoast.showToast(
                          msg: 'Comment posted successfully!',
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
                      backgroundColor: const Color.fromARGB(255, 68, 86, 148)),
                  child: const Text('Post', style: TextStyle(fontSize: 15)),
                )),
          ]);
  }
}

class PostPageNoComment extends StatefulWidget {
  final String jwt;
  final int postid;
  final Function addCallBack;

  const PostPageNoComment(
      {Key? key,
      required this.jwt,
      required this.postid,
      required this.addCallBack})
      : super(key: key);

  @override
  PostPageNoCommentState createState() => PostPageNoCommentState();
}

class PostPageNoCommentState extends State<PostPageNoComment> {
  final contentText = TextEditingController();
  final httpHelpers = HttpHelpers();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    contentText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.jwt == ''
        ? Container(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            alignment: Alignment.centerLeft,
            child: const Text('No comments yet'))
        : Column(children: [
            Container(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 5),
                alignment: Alignment.centerLeft,
                child: const Text('No comments yet')),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
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
                margin: const EdgeInsets.only(top: 6, right: 20, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    httpHelpers
                        .addCommentRequest(
                            widget.postid, contentText.text, widget.jwt)
                        .then((response) {
                      if (response == 'Comment Posted') {
                        widget.addCallBack(response);
                        Fluttertoast.showToast(
                          msg: 'Comment posted successfully!',
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
                      backgroundColor: const Color.fromARGB(255, 68, 86, 148)),
                  child: const Text('Post', style: TextStyle(fontSize: 15)),
                )),
          ]);
  }
}

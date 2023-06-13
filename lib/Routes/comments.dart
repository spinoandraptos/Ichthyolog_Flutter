import 'package:flutter/material.dart';
import '../Models/comment.dart';
import '../Helpers/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OwnComment extends StatelessWidget {
  final Comment comment;
  final httpHelpers = HttpHelpers();
  final String jwt;
  Function deleteCallBack;
  OwnComment(
      {Key? key,
      required this.comment,
      required this.jwt,
      required this.deleteCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: ListTile(
            horizontalTitleGap: 10,
            contentPadding: const EdgeInsets.only(left: 20, right: 20),
            leading: CircleAvatar(
                radius: 18, backgroundImage: NetworkImage(comment.authorPic)),
            title: Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Text(
                            comment.authorName,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 51, 64, 113)),
                          )),
                      Text(comment.content)
                    ])),
            subtitle: Text(
              'Posted at ${comment.postedTime}',
              style: const TextStyle(fontSize: 11),
            ),
          )),
      Row(
        children: [
          TextButton(onPressed: () {}, child: const Text('Edit Comment')),
          TextButton(
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
                                    backgroundColor: const Color.fromARGB(
                                        255, 80, 170, 121)),
                                child: const Text("Yes"),
                                onPressed: () {
                                  httpHelpers
                                      .deleteCommentRequest(
                                          comment.commentId, jwt)
                                      .then(
                                    (response) {
                                      print(comment.commentId);
                                      Navigator.pop(context);
                                      if (response == 'Comment Deleted') {
                                        deleteCallBack(response);
                                        Fluttertoast.showToast(
                                          msg: 'Comment deleted',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                        );
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: 'Comment failed to delete :(',
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
              child: const Text('Delete Comment'))
        ],
      )
    ]);
  }
}

class OtherComment extends StatelessWidget {
  final Comment comment;
  const OtherComment({Key? key, required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ListTile(
          horizontalTitleGap: 10,
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
          leading: CircleAvatar(
              radius: 18, backgroundImage: NetworkImage(comment.authorPic)),
          title: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          comment.authorName,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        )),
                    Text(comment.content)
                  ])),
          subtitle: Text(
            'Posted at ${comment.postedTime}',
            style: const TextStyle(fontSize: 11),
          ),
        ));
  }
}

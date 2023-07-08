import 'package:flutter/material.dart';
import '../Models/comment.dart';
import '../Models/species.dart';
import '../Models/user.dart';
import 'comment_disputes.dart';
import '../Helpers/http.dart';
import '../Helpers/standard_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OwnComment extends StatefulWidget {
  final Comment comment;
  final String jwt;
  final Function updateCallBack;
  final int userid;
  final int postid;
  final User currUser;
  const OwnComment(
      {Key? key,
      required this.comment,
      required this.jwt,
      required this.updateCallBack,
      required this.userid,
      required this.postid,
      required this.currUser})
      : super(key: key);

  @override
  OwnCommentState createState() => OwnCommentState();
}

class OwnCommentState extends State<OwnComment> {
  final httpHelpers = HttpHelpers();
  String updatedContent = '';
  bool upvoted = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          httpHelpers.checkUpvoteStatus(
              widget.comment.commentId, widget.jwt, widget.userid),
          httpHelpers.checkDownvoteStatus(
              widget.comment.commentId, widget.jwt, widget.userid)
        ]),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: ListTile(
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(left: 20, right: 20),
                    leading: CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(widget.comment.authorPic)),
                    title: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.comment.idSuggestion
                                ? [
                                    Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2),
                                            child: Text(
                                              widget.comment.authorName,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 51, 64, 113)),
                                            )),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 2),
                                            child: widget
                                                    .comment.suggestionApproved
                                                ? widget.comment.idReplaced
                                                    ? const Text(
                                                        '’s ID is revoked',
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      )
                                                    : const Text(
                                                        '’s ID is approved',
                                                        style: TextStyle(
                                                            fontSize: 13),
                                                      )
                                                : const Text(
                                                    ' suggested an ID:',
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  )),
                                      ],
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(2),
                                        color: widget.comment.suggestionApproved
                                            ? widget.comment.idReplaced
                                                ? const Color.fromARGB(
                                                    255, 243, 243, 243)
                                                : const Color.fromARGB(
                                                    255, 231, 250, 237)
                                            : const Color.fromARGB(
                                                255, 231, 237, 250),
                                        child: Text(singaporeRecords
                                            .singleWhere((record) =>
                                                '${record.commonNames} (${record.species})' ==
                                                widget.comment.content)
                                            .species))
                                  ]
                                : [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Text(
                                          widget.comment.authorName,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 51, 64, 113)),
                                        )),
                                    Text(widget.comment.content)
                                  ])),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.comment.edited
                                ? 'Edited at ${widget.comment.editedTime}'
                                : 'Posted at ${widget.comment.postedTime}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          Container(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    widget.comment.idSuggestion &&
                                            widget.currUser.expert
                                        ? [
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            title: const Text(
                                                                "Edit Comment"),
                                                            content:
                                                                TextFormField(
                                                              initialValue:
                                                                  widget.comment
                                                                      .content,
                                                              minLines: 1,
                                                              maxLines: 10,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Edit Comment",
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  updatedContent =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          80,
                                                                          170,
                                                                          121)),
                                                                  child: const Text(
                                                                      "Confirm"),
                                                                  onPressed:
                                                                      () {
                                                                    httpHelpers
                                                                        .editCommentRequest(
                                                                            widget
                                                                                .comment.commentId,
                                                                            updatedContent,
                                                                            widget
                                                                                .jwt)
                                                                        .then(
                                                                            (response) {
                                                                      if (response ==
                                                                          'Comment Edited') {
                                                                        widget.updateCallBack(
                                                                            response);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                              'Comment Edited',
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                        );
                                                                      } else {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                              'Comment Edit Failed :(',
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                        );
                                                                      }
                                                                    });
                                                                  }),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          170,
                                                                          80,
                                                                          80)),
                                                                  child: const Text(
                                                                      "Cancel"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  })
                                                            ]);
                                                      });
                                                },
                                                child: const Text('Edit',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Color.fromARGB(
                                                            255,
                                                            68,
                                                            95,
                                                            143)))),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            title: const Text(
                                                                "Warning"),
                                                            content: const Text(
                                                                'Are you sure? This action is irreversible!'),
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          80,
                                                                          170,
                                                                          121)),
                                                                  child:
                                                                      const Text(
                                                                          "Yes"),
                                                                  onPressed:
                                                                      () {
                                                                    httpHelpers
                                                                        .deleteCommentRequest(
                                                                            widget.comment.commentId,
                                                                            widget.jwt)
                                                                        .then(
                                                                      (response) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        if (response ==
                                                                            'Comment Deleted') {
                                                                          widget
                                                                              .updateCallBack(response);
                                                                          Fluttertoast
                                                                              .showToast(
                                                                            msg:
                                                                                'Comment deleted',
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            gravity:
                                                                                ToastGravity.BOTTOM,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                          );
                                                                        } else {
                                                                          Fluttertoast
                                                                              .showToast(
                                                                            msg:
                                                                                'Comment failed to delete :(',
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            gravity:
                                                                                ToastGravity.BOTTOM,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                          );
                                                                        }
                                                                      },
                                                                    );
                                                                  }),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          170,
                                                                          80,
                                                                          80)),
                                                                  child: const Text(
                                                                      "Cancel"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  })
                                                            ]);
                                                      });
                                                },
                                                child: const Text('Delete',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Color.fromARGB(
                                                            255,
                                                            68,
                                                            95,
                                                            143)))),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap),
                                                onPressed: () {
                                                  widget.comment
                                                          .suggestionApproved
                                                      ? showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            TextEditingController
                                                                disputeController =
                                                                TextEditingController();
                                                            return AlertDialog(
                                                              title: const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                      'Submit Dispute')),
                                                              content:
                                                                  Container(
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8,
                                                                          left:
                                                                              5,
                                                                          right:
                                                                              5),
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      decoration: BoxDecoration(
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              225,
                                                                              235,
                                                                              248),
                                                                          borderRadius: BorderRadius.circular(
                                                                              16)),
                                                                      child:
                                                                          TextField(
                                                                        controller:
                                                                            disputeController,
                                                                        minLines:
                                                                            1,
                                                                        maxLines:
                                                                            8,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          focusColor: const Color.fromARGB(
                                                                              255,
                                                                              51,
                                                                              64,
                                                                              113),
                                                                          hintText:
                                                                              'Reason for dispute',
                                                                          border:
                                                                              InputBorder.none,
                                                                          suffixIcon:
                                                                              IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              disputeController.clear();
                                                                            },
                                                                            icon:
                                                                                const Icon(Icons.clear),
                                                                          ),
                                                                        ),
                                                                      )),
                                                              actions: [
                                                                Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10,
                                                                        bottom:
                                                                            7),
                                                                    child: Wrap(
                                                                        spacing:
                                                                            5,
                                                                        children: [
                                                                          ElevatedButton(
                                                                              onPressed: () {
                                                                                httpHelpers.addDisputeRequest(widget.comment.commentId, disputeController.text, widget.jwt).then(
                                                                                  (response) {
                                                                                    Fluttertoast.showToast(
                                                                                      msg: response,
                                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                                      gravity: ToastGravity.BOTTOM,
                                                                                      timeInSecForIosWeb: 1,
                                                                                    );
                                                                                    if (response == 'Dispute added successfully!') {
                                                                                      setState(() {});
                                                                                      Navigator.pop(context);
                                                                                    }
                                                                                  },
                                                                                );
                                                                              },
                                                                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap, backgroundColor: const Color.fromARGB(255, 80, 170, 121)),
                                                                              child: const Text("Submit")),
                                                                          ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap, backgroundColor: const Color.fromARGB(255, 170, 80, 80)),
                                                                              child: const Text("Cancel"),
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              })
                                                                        ]))
                                                              ],
                                                            );
                                                          })
                                                      : httpHelpers
                                                          .acceptIdSuggestionRequest(
                                                              widget.postid,
                                                              widget.comment
                                                                  .commentId,
                                                              widget.comment
                                                                  .content,
                                                              widget.jwt)
                                                          .then(
                                                          (response) {
                                                            if (response ==
                                                                'Approved ID Already Exists') {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return const NoticeDialog(
                                                                        content:
                                                                            'Sighting ID already approved! To challenge existing ID, please submit a dispute.');
                                                                  });
                                                            } else {
                                                              Fluttertoast
                                                                  .showToast(
                                                                msg: response,
                                                                toastLength: Toast
                                                                    .LENGTH_SHORT,
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                timeInSecForIosWeb:
                                                                    1,
                                                              );
                                                              if (response ==
                                                                  'ID Suggestion Accepted') {
                                                                widget.updateCallBack(
                                                                    response);
                                                              }
                                                            }
                                                          },
                                                        );
                                                },
                                                child: widget.comment
                                                        .suggestionApproved
                                                    ? const Text('Dispute Approval',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color.fromARGB(
                                                                255, 68, 95, 143)))
                                                    : const Text('Accept ID',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Color.fromARGB(
                                                                255, 68, 95, 143)))),
                                          ]
                                        : [
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            title: const Text(
                                                                "Edit Comment"),
                                                            content:
                                                                TextFormField(
                                                              initialValue:
                                                                  widget.comment
                                                                      .content,
                                                              minLines: 1,
                                                              maxLines: 10,
                                                              decoration:
                                                                  const InputDecoration(
                                                                hintText:
                                                                    "Edit Comment",
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  updatedContent =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          80,
                                                                          170,
                                                                          121)),
                                                                  child: const Text(
                                                                      "Confirm"),
                                                                  onPressed:
                                                                      () {
                                                                    httpHelpers
                                                                        .editCommentRequest(
                                                                            widget
                                                                                .comment.commentId,
                                                                            updatedContent,
                                                                            widget
                                                                                .jwt)
                                                                        .then(
                                                                            (response) {
                                                                      if (response ==
                                                                          'Comment Edited') {
                                                                        widget.updateCallBack(
                                                                            response);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                              'Comment Edited',
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                        );
                                                                      } else {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                              'Comment Edit Failed :(',
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                        );
                                                                      }
                                                                    });
                                                                  }),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          170,
                                                                          80,
                                                                          80)),
                                                                  child: const Text(
                                                                      "Cancel"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  })
                                                            ]);
                                                      });
                                                },
                                                child: const Text('Edit',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Color.fromARGB(
                                                            255,
                                                            68,
                                                            95,
                                                            143)))),
                                            TextButton(
                                                style: TextButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(3),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap),
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                            title: const Text(
                                                                "Warning"),
                                                            content: const Text(
                                                                'Are you sure? This action is irreversible!'),
                                                            actions: [
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          80,
                                                                          170,
                                                                          121)),
                                                                  child:
                                                                      const Text(
                                                                          "Yes"),
                                                                  onPressed:
                                                                      () {
                                                                    httpHelpers
                                                                        .deleteCommentRequest(
                                                                            widget.comment.commentId,
                                                                            widget.jwt)
                                                                        .then(
                                                                      (response) {
                                                                        Navigator.pop(
                                                                            context);
                                                                        if (response ==
                                                                            'Comment Deleted') {
                                                                          widget
                                                                              .updateCallBack(response);
                                                                          Fluttertoast
                                                                              .showToast(
                                                                            msg:
                                                                                'Comment deleted',
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            gravity:
                                                                                ToastGravity.BOTTOM,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                          );
                                                                        } else {
                                                                          Fluttertoast
                                                                              .showToast(
                                                                            msg:
                                                                                'Comment failed to delete :(',
                                                                            toastLength:
                                                                                Toast.LENGTH_SHORT,
                                                                            gravity:
                                                                                ToastGravity.BOTTOM,
                                                                            timeInSecForIosWeb:
                                                                                1,
                                                                          );
                                                                        }
                                                                      },
                                                                    );
                                                                  }),
                                                              ElevatedButton(
                                                                  style: ElevatedButton.styleFrom(
                                                                      backgroundColor: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          170,
                                                                          80,
                                                                          80)),
                                                                  child: const Text(
                                                                      "Cancel"),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  })
                                                            ]);
                                                      });
                                                },
                                                child: const Text('Delete ',
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Color.fromARGB(
                                                            255,
                                                            68,
                                                            95,
                                                            143)))),
                                          ],
                              ))
                        ]),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${widget.comment.upvotes}'),
                        InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              widget.jwt == ''
                                  ? Fluttertoast.showToast(
                                      msg: 'Please login to upvote',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                    )
                                  : snapshot.data![0]
                                      ? httpHelpers
                                          .unUpVoteCommentRequest(
                                              widget.comment.commentId,
                                              widget.userid,
                                              widget.jwt)
                                          .then((response) {
                                          if (response ==
                                              'Comment Un-upvoted') {
                                            widget.updateCallBack(response);
                                            Fluttertoast.showToast(
                                              msg: 'Upvote Removed',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: 'Error :(',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                            );
                                          }
                                        })
                                      : widget.comment.upvotes == 29
                                          ? httpHelpers
                                              .upVoteCommentRequest(
                                                  widget.comment.commentId,
                                                  widget.userid,
                                                  widget.jwt)
                                              .then((response) {
                                              if (response ==
                                                  'Comment Upvoted') {
                                                widget.updateCallBack(response);
                                                httpHelpers.verifyPostRequest(
                                                    widget.comment.postId,
                                                    widget.jwt);
                                                Fluttertoast.showToast(
                                                  msg: 'Comment upvoted',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Comment failed to upvote :(',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              }
                                            })
                                          : httpHelpers
                                              .upVoteCommentRequest(
                                                  widget.comment.commentId,
                                                  widget.userid,
                                                  widget.jwt)
                                              .then((response) {
                                              if (response ==
                                                  'Comment Upvoted') {
                                                widget.updateCallBack(response);
                                                Fluttertoast.showToast(
                                                  msg: 'Comment upvoted',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Comment failed to upvote :(',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              }
                                            });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: snapshot.data![0]
                                    ? const Icon(
                                        Icons.arrow_upward,
                                        size: 20,
                                        color:
                                            Color.fromARGB(255, 73, 155, 109),
                                      )
                                    : const Icon(
                                        Icons.arrow_upward,
                                        size: 20,
                                      ))),
                        InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              widget.jwt == ''
                                  ? Fluttertoast.showToast(
                                      msg: 'Please login to downvote',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                    )
                                  : snapshot.data![1]
                                      ? httpHelpers
                                          .unDownVoteCommentRequest(
                                              widget.comment.commentId,
                                              widget.userid,
                                              widget.jwt)
                                          .then((response) {
                                          if (response ==
                                              'Comment Un-downvoted') {
                                            widget.updateCallBack(response);
                                            Fluttertoast.showToast(
                                              msg: 'Downvote Removed',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                            );
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: 'Error :(',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                            );
                                          }
                                        })
                                      : httpHelpers
                                          .downVoteCommentRequest(
                                              widget.comment.commentId,
                                              widget.userid,
                                              widget.jwt)
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
                                              msg:
                                                  'Comment failed to Downvote :(',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                            );
                                          }
                                        });
                            },
                            child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: snapshot.data![1]
                                    ? const Icon(
                                        Icons.arrow_downward,
                                        size: 20,
                                        color: Color.fromARGB(255, 152, 72, 85),
                                      )
                                    : const Icon(Icons.arrow_downward,
                                        size: 20))),
                      ],
                    ),
                  )),
            ]);
          } else if (snapshot.hasError) {
            return Text('ERROR: ${snapshot.error}');
          } else {
            return loadingComment();
          }
        }));
  }
}

class OtherComment extends StatefulWidget {
  final Comment comment;
  final String jwt;
  final Function updateCallBack;
  final int userid;
  final int postid;
  final User currUser;
  const OtherComment(
      {Key? key,
      required this.comment,
      required this.jwt,
      required this.updateCallBack,
      required this.userid,
      required this.postid,
      required this.currUser})
      : super(key: key);

  @override
  OtherCommentState createState() => OtherCommentState();
}

class OtherCommentState extends State<OtherComment> {
  final httpHelpers = HttpHelpers();
  bool upvoted = false;
  late List<int> upvoterIDs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          httpHelpers.checkUpvoteStatus(
              widget.comment.commentId, widget.jwt, widget.userid),
          httpHelpers.checkDownvoteStatus(
              widget.comment.commentId, widget.jwt, widget.userid)
        ]),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
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
                          children: widget.comment.idSuggestion
                              ? [
                                  Row(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 2),
                                          child: Text(
                                            widget.comment.authorName,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 51, 64, 113)),
                                          )),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 2),
                                          child: widget
                                                  .comment.suggestionApproved
                                              ? widget.comment.idReplaced
                                                  ? const Text(
                                                      '’s ID is revoked',
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    )
                                                  : const Text(
                                                      '’s ID is approved',
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    )
                                              : const Text(
                                                  ' suggested an ID:',
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )),
                                    ],
                                  ),
                                  Container(
                                      padding: const EdgeInsets.all(2),
                                      color: widget.comment.suggestionApproved
                                          ? widget.comment.idReplaced
                                              ? const Color.fromARGB(
                                                  255, 243, 243, 243)
                                              : const Color.fromARGB(
                                                  255, 231, 250, 237)
                                          : const Color.fromARGB(
                                              255, 231, 237, 250),
                                      child: Text(singaporeRecords
                                          .singleWhere((record) =>
                                              '${record.commonNames} (${record.species})' ==
                                              widget.comment.content)
                                          .species))
                                ]
                              : [
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text(
                                        widget.comment.authorName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color.fromARGB(
                                                255, 51, 64, 113)),
                                      )),
                                  Text(widget.comment.content)
                                ])),
                  subtitle:
                      widget.comment.idSuggestion && widget.currUser.expert
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    widget.comment.edited
                                        ? 'Edited at ${widget.comment.editedTime}'
                                        : 'Posted at ${widget.comment.postedTime}',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.only(
                                          top: 4, bottom: 4),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children:
                                              widget.comment.suggestionApproved
                                                  ? [
                                                      TextButton(
                                                          style: TextButton.styleFrom(
                                                              padding: const EdgeInsets.all(
                                                                  3),
                                                              minimumSize:
                                                                  Size.zero,
                                                              tapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap),
                                                          onPressed: () {},
                                                          child: widget.comment
                                                                  .idReplaced
                                                              ? const Text(
                                                                  'Re-approve ID',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          68,
                                                                          95,
                                                                          143)))
                                                              : const Text(
                                                                  'Dispute Approval',
                                                                  style: TextStyle(fontSize: 10, color: Color.fromARGB(255, 68, 95, 143)))),
                                                    ]
                                                  : [
                                                      TextButton(
                                                          style: TextButton.styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                              minimumSize:
                                                                  Size.zero,
                                                              tapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap),
                                                          onPressed: () {
                                                            widget.comment
                                                                    .suggestionApproved
                                                                ? showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      TextEditingController
                                                                          disputeController =
                                                                          TextEditingController();
                                                                      return AlertDialog(
                                                                        title: const Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: 5),
                                                                            child: Text('Submit Dispute')),
                                                                        content: Container(
                                                                            margin: const EdgeInsets.only(top: 8, left: 5, right: 5),
                                                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                            decoration: BoxDecoration(color: const Color.fromARGB(255, 225, 235, 248), borderRadius: BorderRadius.circular(16)),
                                                                            child: TextField(
                                                                              controller: disputeController,
                                                                              minLines: 1,
                                                                              maxLines: 8,
                                                                              decoration: InputDecoration(
                                                                                focusColor: const Color.fromARGB(255, 51, 64, 113),
                                                                                hintText: 'Reason for dispute',
                                                                                border: InputBorder.none,
                                                                                suffixIcon: IconButton(
                                                                                  onPressed: () {
                                                                                    disputeController.clear();
                                                                                  },
                                                                                  icon: const Icon(Icons.clear),
                                                                                ),
                                                                              ),
                                                                            )),
                                                                        actions: [
                                                                          Padding(
                                                                              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 7),
                                                                              child: Wrap(spacing: 5, children: [
                                                                                ElevatedButton(
                                                                                    onPressed: () {
                                                                                      httpHelpers.addDisputeRequest(widget.comment.commentId, disputeController.text, widget.jwt).then(
                                                                                        (response) {
                                                                                          Fluttertoast.showToast(
                                                                                            msg: response,
                                                                                            toastLength: Toast.LENGTH_SHORT,
                                                                                            gravity: ToastGravity.BOTTOM,
                                                                                            timeInSecForIosWeb: 1,
                                                                                          );
                                                                                          if (response == 'Dispute added successfully!') {
                                                                                            setState(() {});
                                                                                          }
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap, backgroundColor: const Color.fromARGB(255, 80, 170, 121)),
                                                                                    child: const Text("Submit")),
                                                                                ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(8), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap, backgroundColor: const Color.fromARGB(255, 170, 80, 80)),
                                                                                    child: const Text("Cancel"),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    })
                                                                              ]))
                                                                        ],
                                                                      );
                                                                    })
                                                                : httpHelpers
                                                                    .acceptIdSuggestionRequest(
                                                                        widget
                                                                            .postid,
                                                                        widget
                                                                            .comment
                                                                            .commentId,
                                                                        widget
                                                                            .comment
                                                                            .content,
                                                                        widget
                                                                            .jwt)
                                                                    .then(
                                                                    (response) {
                                                                      if (response ==
                                                                          'Approved ID Already Exists') {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return const NoticeDialog(content: 'Sighting ID already approved! To challenge existing ID, please submit a dispute.');
                                                                            });
                                                                      } else {
                                                                        Fluttertoast
                                                                            .showToast(
                                                                          msg:
                                                                              response,
                                                                          toastLength:
                                                                              Toast.LENGTH_SHORT,
                                                                          gravity:
                                                                              ToastGravity.BOTTOM,
                                                                          timeInSecForIosWeb:
                                                                              1,
                                                                        );
                                                                        if (response ==
                                                                            'ID Suggestion Accepted') {
                                                                          widget
                                                                              .updateCallBack(response);
                                                                        }
                                                                      }
                                                                    },
                                                                  );
                                                          },
                                                          child: const Text(
                                                              'Approve ID',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          68,
                                                                          95,
                                                                          143)))),
                                                      TextButton(
                                                          style: TextButton.styleFrom(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(3),
                                                              minimumSize:
                                                                  Size.zero,
                                                              tapTargetSize:
                                                                  MaterialTapTargetSize
                                                                      .shrinkWrap),
                                                          onPressed: () {},
                                                          child: const Text(
                                                              'Dispute ID',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          68,
                                                                          95,
                                                                          143))))
                                                    ])),
                                ])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(
                                    widget.comment.edited
                                        ? 'Posted at ${widget.comment.editedTime}'
                                        : 'Posted at ${widget.comment.postedTime}',
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${widget.comment.upvotes}'),
                      InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            widget.jwt == ''
                                ? Fluttertoast.showToast(
                                    msg: 'Please login to upvote',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  )
                                : snapshot.data![0]
                                    ? httpHelpers
                                        .unUpVoteCommentRequest(
                                            widget.comment.commentId,
                                            widget.userid,
                                            widget.jwt)
                                        .then((response) {
                                        if (response == 'Comment Un-upvoted') {
                                          widget.updateCallBack(response);
                                          Fluttertoast.showToast(
                                            msg: 'Upvote Removed',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: 'Error :(',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        }
                                      })
                                    : widget.comment.upvotes == 29
                                        ? httpHelpers
                                            .upVoteCommentRequest(
                                                widget.comment.commentId,
                                                widget.userid,
                                                widget.jwt)
                                            .then((response) {
                                            if (response == 'Comment Upvoted') {
                                              widget.updateCallBack(response);
                                              httpHelpers.verifyPostRequest(
                                                  widget.comment.postId,
                                                  widget.jwt);
                                              Fluttertoast.showToast(
                                                msg: 'Comment upvoted',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                              );
                                            } else {
                                              Fluttertoast.showToast(
                                                msg:
                                                    'Comment failed to upvote :(',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                              );
                                            }
                                          })
                                        : httpHelpers
                                            .upVoteCommentRequest(
                                                widget.comment.commentId,
                                                widget.userid,
                                                widget.jwt)
                                            .then((response) {
                                            if (response == 'Comment Upvoted') {
                                              widget.updateCallBack(response);
                                              Fluttertoast.showToast(
                                                msg: 'Comment upvoted',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                              );
                                            } else {
                                              Fluttertoast.showToast(
                                                msg:
                                                    'Comment failed to upvote :(',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                              );
                                            }
                                          });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: snapshot.data![0]
                                  ? const Icon(
                                      Icons.arrow_upward,
                                      size: 20,
                                      color: Color.fromARGB(255, 73, 155, 109),
                                    )
                                  : const Icon(
                                      Icons.arrow_upward,
                                      size: 20,
                                    ))),
                      InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            widget.jwt == ''
                                ? Fluttertoast.showToast(
                                    msg: 'Please login to downvote',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  )
                                : snapshot.data![1]
                                    ? httpHelpers
                                        .unDownVoteCommentRequest(
                                            widget.comment.commentId,
                                            widget.userid,
                                            widget.jwt)
                                        .then((response) {
                                        if (response ==
                                            'Comment Un-downvoted') {
                                          widget.updateCallBack(response);
                                          Fluttertoast.showToast(
                                            msg: 'Downvote Removed',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: 'Error :(',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        }
                                      })
                                    : httpHelpers
                                        .downVoteCommentRequest(
                                            widget.comment.commentId,
                                            widget.userid,
                                            widget.jwt)
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
                                            msg:
                                                'Comment failed to Downvote :(',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                        }
                                      });
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: snapshot.data![1]
                                  ? const Icon(
                                      Icons.arrow_downward,
                                      size: 20,
                                      color: Color.fromARGB(255, 152, 72, 85),
                                    )
                                  : const Icon(Icons.arrow_downward,
                                      size: 20))),
                    ],
                  ),
                ));
          } else if (snapshot.hasError) {
            return Text('ERROR: ${snapshot.error}');
          } else {
            return loadingComment();
          }
        }));
  }
}

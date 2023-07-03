import 'package:flutter/material.dart';
import '../Models/comment.dart';
import '../Helpers/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'comments_page.dart';
import 'comments.dart';
import '../Models/species.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../Helpers/standard_widgets.dart';

class PostPageMultiComment extends StatelessWidget {
  final List<Comment> comments;
  final httpHelpers = HttpHelpers();
  final String jwt;
  final int postid;
  final bool isExpert;
  PostPageMultiComment(
      {Key? key,
      required this.comments,
      required this.jwt,
      required this.postid,
      required this.isExpert})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.only(left: 20, right: 20),
        leading: CircleAvatar(
            radius: 18, backgroundImage: NetworkImage(comments[0].authorPic)),
        title: Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    comments[0].authorName,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 51, 64, 113)),
                  )),
              Text(comments[comments.length - 1].content)
            ])),
        subtitle: Text(
          'Posted at ${comments[0].postedTime}',
          style: const TextStyle(fontSize: 11),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    CommentPage(postid: postid, isExpert: isExpert)),
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
  final bool isExpert;
  final Map<String, dynamic> decodedJWT;
  final Function updateCallBack;

  const PostPageSingleComment(
      {Key? key,
      required this.comments,
      required this.jwt,
      required this.postid,
      required this.decodedJWT,
      required this.updateCallBack,
      required this.isExpert})
      : super(key: key);

  @override
  PostPageSingleCommentState createState() => PostPageSingleCommentState();
}

class PostPageSingleCommentState extends State<PostPageSingleComment> {
  final contentText = TextEditingController();
  final httpHelpers = HttpHelpers();
  bool suggestingID = false;
  List<String> allSpecies = <String>[];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    contentText.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.jwt != '') {
      for (var record in singaporeRecords) {
        allSpecies.add(record.commonNames);
      }
    }
  }

  clearCallback() {
    setState(() {
      contentText.clear();
    });
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
              userid: widget.decodedJWT['userid'] ?? -1,
              postid: widget.postid,
              isExpert: widget.isExpert,
            ))
        : Column(children: [
            widget.comments[widget.comments.length - 1].authorId ==
                    widget.decodedJWT['userid']
                ? OwnComment(
                    comment: widget.comments[widget.comments.length - 1],
                    jwt: widget.jwt,
                    updateCallBack: widget.updateCallBack,
                    userid: widget.decodedJWT['userid'],
                    postid: widget.postid,
                    isExpert: widget.isExpert,
                  )
                : OtherComment(
                    comment: widget.comments[widget.comments.length - 1],
                    jwt: widget.jwt,
                    updateCallBack: widget.updateCallBack,
                    userid: widget.decodedJWT['userid'],
                    postid: widget.postid,
                    isExpert: widget.isExpert,
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: suggestingID
                  ? selectableTextForm(
                      contentText, 'Suggest an ID', allSpecies, clearCallback)
                  : TextFormField(
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
                  top: 6, left: 20, right: 20, bottom: 10),
              child: Wrap(spacing: 10, children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      suggestingID = !suggestingID;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: suggestingID
                          ? const Color.fromARGB(255, 79, 142, 112)
                          : Color.fromARGB(255, 170, 99, 117)),
                  child: suggestingID
                      ? const Text('ID Suggestion Mode: On',
                          style: TextStyle(fontSize: 15))
                      : const Text('ID Suggestion Mode: Off',
                          style: TextStyle(fontSize: 15)),
                ),
                ElevatedButton(
                  onPressed: () {
                    suggestingID
                        ? httpHelpers
                            .addIdSuggestionRequest(
                                widget.postid, contentText.text, widget.jwt)
                            .then((response) {
                            if (response == 'Comment Posted') {
                              widget.updateCallBack(response);
                              Fluttertoast.showToast(
                                msg: 'ID suggestion posted successfully!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                              setState(() {
                                contentText.clear();
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: 'ID suggestion failed to post :(',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          })
                        : httpHelpers
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
                )
              ]),
            )
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
  bool suggestingID = false;
  List<String> allSpecies = <String>[];

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree
    contentText.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.jwt != '') {
      setState(() {
        for (var record in singaporeRecords) {
          allSpecies.add(record.commonNames);
        }
      });
    }
  }

  clearCallback() {
    setState(() {
      contentText.clear();
    });
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
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: suggestingID
                  ? selectableTextForm(
                      contentText, 'Suggest an ID', allSpecies, clearCallback)
                  : TextFormField(
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
                  top: 6, left: 20, right: 20, bottom: 10),
              child: Wrap(spacing: 10, children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      suggestingID = !suggestingID;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: suggestingID
                          ? const Color.fromARGB(255, 79, 142, 112)
                          : const Color.fromARGB(255, 170, 99, 117)),
                  child: suggestingID
                      ? const Text('ID Suggestion Mode: On',
                          style: TextStyle(fontSize: 15))
                      : const Text('ID Suggestion Mode: Off',
                          style: TextStyle(fontSize: 15)),
                ),
                ElevatedButton(
                  onPressed: () {
                    suggestingID
                        ? httpHelpers
                            .addIdSuggestionRequest(
                                widget.postid, contentText.text, widget.jwt)
                            .then((response) {
                            if (response == 'Comment Posted') {
                              widget.addCallBack(response);
                              Fluttertoast.showToast(
                                msg: 'ID suggestion posted successfully!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                              setState(() {
                                contentText.clear();
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: 'ID suggestion failed to post :(',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                              );
                            }
                          })
                        : httpHelpers
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
                )
              ]),
            ),
          ]);
  }
}

Widget selectableTextForm(TextEditingController controller, String hintText,
    List<String> options, Function callback) {
  return TypeAheadFormField(
    hideOnLoading: true,
    hideOnEmpty: true,
    textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          focusColor: const Color.fromARGB(255, 51, 64, 113),
          hintText: hintText,
          suffixIcon: IconButton(
            onPressed: () {
              callback();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
        autofocus: true,
        style: const TextStyle(color: Color.fromARGB(255, 51, 64, 113))),
    itemBuilder: (context, suggestion) {
      return ListTile(
        title: Text(suggestion),
      );
    },
    errorBuilder: (context, error) {
      return NoticeDialog(content: '$error');
    },
    suggestionsCallback: (pattern) {
      List<String> matches = [];
      if (pattern == '') {
        return matches;
      } else {
        matches.addAll(options);
        matches.retainWhere((matches) {
          return matches.toLowerCase().contains(pattern.toLowerCase());
        });
        return matches;
      }
    },
    onSuggestionSelected: (suggestion) {
      controller.text = suggestion;
    },
  );
}

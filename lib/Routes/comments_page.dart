import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Helpers/standard_widgets.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'comments.dart';
import '../Models/species.dart';
import '../Models/user.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'comment_disputes.dart';

class CommentPage extends StatefulWidget {
  final int postid;
  final User currUser;
  const CommentPage({Key? key, required this.postid, required this.currUser})
      : super(key: key);
  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends State<CommentPage> {
  String jwt = '';
  Map<String, dynamic> decodedJWT = {};
  final contentText = TextEditingController();
  bool suggestingID = false;
  final httpHelpers = HttpHelpers();
  final helpers = Helpers();
  List<String> allSpecies = <String>[];
  bool addIdRequestProcessing = false;
  bool addCommentRequestProcessing = false;

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
          for (var record in singaporeRecords) {
            allSpecies.add('${record.commonNames} (${record.species})');
          }
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

  clearCallback() {
    setState(() {
      contentText.clear();
    });
  }

  updateCallback() {
    setState(() {});
  }

  addIdRequestProcessingCallback() {
    setState(() {
      addIdRequestProcessing = !addIdRequestProcessing;
    });
  }

  addCommentRequestProcessingCallback() {
    setState(() {
      addCommentRequestProcessing = !addCommentRequestProcessing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewPostCommentsRequest(widget.postid),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text('Comments'),
                  backgroundColor: const Color.fromARGB(255, 65, 90, 181),
                ),
                body: SingleChildScrollView(
                    child: Column(children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                      padding: const EdgeInsets.only(top: 6),
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 7 / 10,
                      ),
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Column(children: [
                            jwt == ''
                                ? OtherComment(
                                    comment: snapshot.data![index],
                                    jwt: jwt,
                                    updateCallBack: updateCommentCallback,
                                    userid: decodedJWT['userid'] ?? -1,
                                    postid: widget.postid,
                                    currUser: widget.currUser,
                                  )
                                : snapshot.data![index].authorName ==
                                        decodedJWT['username']
                                    ? OwnComment(
                                        comment: snapshot.data![index],
                                        jwt: jwt,
                                        updateCallBack: updateCommentCallback,
                                        userid: decodedJWT['userid'],
                                        postid: widget.postid,
                                        currUser: widget.currUser,
                                      )
                                    : OtherComment(
                                        comment: snapshot.data![index],
                                        jwt: jwt,
                                        updateCallBack: updateCommentCallback,
                                        userid: decodedJWT['userid'],
                                        postid: widget.postid,
                                        currUser: widget.currUser,
                                      ),
                            snapshot.data![index].idSuggestion
                                ? CommentDisputes(
                                    currUser: widget.currUser,
                                    comment: snapshot.data![index],
                                    postid: widget.postid,
                                    jwt: jwt,
                                    updateCallback: updateCallback)
                                : const SizedBox.shrink()
                          ]);
                        },
                      )),
                  jwt == ''
                      ? const SizedBox.shrink()
                      : Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: suggestingID
                                ? selectableTextForm(contentText,
                                    'Suggest an ID', allSpecies, clearCallback)
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
                                          ? const Color.fromARGB(
                                              255, 79, 142, 112)
                                          : const Color.fromARGB(
                                              255, 170, 99, 117)),
                                  child: suggestingID
                                      ? const Text('ID Suggestion Mode: On',
                                          style: TextStyle(fontSize: 15))
                                      : const Text('ID Suggestion Mode: Off',
                                          style: TextStyle(fontSize: 15)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (suggestingID) {
                                      if (addIdRequestProcessing) {
                                        null;
                                      } else {
                                        addIdRequestProcessingCallback();
                                        httpHelpers
                                            .addIdSuggestionRequest(
                                                widget.postid,
                                                contentText.text,
                                                jwt)
                                            .then((response) {
                                          addIdRequestProcessingCallback();
                                          Fluttertoast.showToast(
                                            msg: response,
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                          );
                                          if (response ==
                                              'ID suggestion posted successfully!') {
                                            updateCommentCallback(response);
                                            setState(() {
                                              contentText.clear();
                                            });
                                          }
                                        });
                                      }
                                    } else {
                                      if (addCommentRequestProcessing) {
                                        null;
                                      } else {
                                        addCommentRequestProcessingCallback();
                                        httpHelpers
                                            .addCommentRequest(widget.postid,
                                                contentText.text, jwt)
                                            .then((response) {
                                          addCommentRequestProcessingCallback();
                                          if (response == 'Comment Posted') {
                                            updateCommentCallback(response);
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
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 68, 86, 148)),
                                  child: const Text('Post',
                                      style: TextStyle(fontSize: 15)),
                                )
                              ]))
                        ])
                ])));
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
        response == 'Comment Posted' ||
        response == 'Comment Upvoted' ||
        response == 'Comment Downvoted' ||
        response == 'Comment Un-upvoted' ||
        response == 'Comment Un-downvoted' ||
        response == 'Comment Edited' ||
        response == 'ID SUggestion Accepted' ||
        response == 'ID Suggestion Rejected') {
      setState(() {});
    }
  }

  Widget selectableTextForm(TextEditingController controller, String hintText,
      List<String> options, Function callback) {
    return TypeAheadFormField(
      hideOnLoading: true,
      hideOnEmpty: true,
      textFieldConfiguration: TextFieldConfiguration(
          onChanged: (value) => callback(value),
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
}

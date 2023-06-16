import 'package:flutter/material.dart';
import '../Helpers/standard_widgets.dart';
import 'post_page_comments.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PostPage extends StatefulWidget {
  final int postid;
  const PostPage({Key? key, required this.postid}) : super(key: key);
  @override
  PostPageState createState() => PostPageState();
}

class PostPageState extends State<PostPage> {
  String jwt = '';
  Map<String, dynamic> decodedJWT = {};
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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewPostRequest(widget.postid),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text(snapshot.data!.title),
                backgroundColor: const Color.fromARGB(255, 51, 64, 113),
              ),
              body: SingleChildScrollView(
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 6, bottom: 8),
                              child: ListTile(
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
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
                                maxHeight: MediaQuery.of(context).size.height *
                                    3 /
                                    8.25,
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
                                  left: 20, right: 20, top: 15, bottom: 7),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )),
                          Flexible(
                              fit: FlexFit.loose,
                              child: SingleChildScrollView(
                                  child: Container(
                                      padding: const EdgeInsets.only(
                                          left: 20,
                                          top: 5,
                                          right: 20,
                                          bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child:
                                          Text(snapshot.data!.description)))),
                          Column(
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
                                      color: Color.fromARGB(255, 51, 64, 113)),
                                ),
                              ),
                              FutureBuilder(
                                future: httpHelpers
                                    .viewPostCommentsRequest(widget.postid),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.length > 1) {
                                    return PostPageMultiComment(
                                        comments: snapshot.data!,
                                        jwt: jwt,
                                        postid: widget.postid);
                                  } else if (snapshot.hasData &&
                                      snapshot.data!.length == 1) {
                                    return PostPageSingleComment(
                                      comments: snapshot.data!,
                                      jwt: jwt,
                                      decodedJWT: decodedJWT,
                                      postid: widget.postid,
                                      deleteCallBack: changeCommentCallback,
                                      addCallBack: changeCommentCallback,
                                    );
                                  } else {
                                    return PostPageNoComment(
                                        jwt: jwt,
                                        postid: widget.postid,
                                        addCallBack: changeCommentCallback);
                                  }
                                },
                              )
                            ],
                          ),
                        ],
                      ))),
            );
          } else if (snapshot.hasError) {
            return const NoticeDialog(
                content: 'Post not found! Please try again');
          } else {
            return const LoadingScreen();
          }
        }));
  }

  changeCommentCallback(response) {
    if (response == 'Comment Deleted' || response == 'Comment Posted') {
      setState(() {});
    }
  }
}

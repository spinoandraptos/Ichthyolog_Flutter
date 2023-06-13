import 'package:flutter/material.dart';
import 'package:ichthyolog/Helpers/standardwidgets.dart';
import 'package:ichthyolog/Routes/postpagecomments.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'commentsPage.dart';

class PostPage extends StatefulWidget {
  final int postid;
  const PostPage({Key? key, required this.postid}) : super(key: key);
  @override
  PostPageState createState() => PostPageState(postid);
}

class PostPageState extends State<PostPage> {
  String jwt = '';
  int _postid = 0;

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
                                      return PostPageMultiComment(
                                          comments: snapshot.data!,
                                          jwt: jwt,
                                          postid: _postid);
                                    } else if (snapshot.hasData &&
                                        snapshot.data!.length == 1) {
                                      return PostPageSingleComment(
                                          comments: snapshot.data!,
                                          jwt: jwt,
                                          postid: _postid);
                                    } else {
                                      return PostPageNoComment(
                                          jwt: jwt, postid: _postid);
                                    }
                                  },
                                )
                              ],
                            ),
                          )
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
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';

class CommentPage extends StatefulWidget {
  final int postid;
  const CommentPage({Key? key, required this.postid}) : super(key: key);
  @override
  CommentPageState createState() => CommentPageState(this.postid);
}

class CommentPageState extends State<CommentPage> {
  String jwt = '';
  int _postid = 0;
  String content = '';

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
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewPostCommentsRequest(_postid),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
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
                                        4.2 /
                                        6,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                        padding: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: ListTile(
                                            leading: CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    snapshot.data![index]
                                                        .authorPic)),
                                            title: Text(
                                              snapshot.data![index].content,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Color.fromARGB(
                                                      255, 51, 64, 113)),
                                            ),
                                            subtitle: Text(
                                                'Posted at ${snapshot.data![index].postedTime}')));
                                  },
                                )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, left: 25, right: 25),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Reply',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    content = value;
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
                                            _postid, content, jwt)
                                        .then((response) {
                                      if (response == 'Comment Posted') {
                                        Fluttertoast.showToast(
                                          msg: 'Comment posted successfully!',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                        );
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

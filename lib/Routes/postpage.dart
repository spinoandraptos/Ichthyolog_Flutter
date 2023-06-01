import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:http/http.dart';
import 'package:ichthyolog/Models/post.dart';
import 'package:ichthyolog/Models/user.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';

class PostPage extends StatefulWidget {
  final int postid;
  const PostPage({Key? key, required this.postid}) : super(key: key);
  @override
  _PostPageState createState() => _PostPageState(this.postid);
}

class _PostPageState extends State<PostPage> {
  String jwt = '';
  int _postid = 0;
  Post post = Post(
      postid: 0,
      userid: 0,
      authorname: '',
      title: '',
      description: '',
      pic: '',
      uploadTime: '',
      sightingTime: '',
      sightingLocation: '',
      authorpic: '');

  final httpHelpers = HttpHelpers();
  final helpers = Helpers();
  _PostPageState(int postid) {
    _postid = postid;
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
                backgroundColor: Color.fromARGB(255, 51, 64, 113),
              ),
              body: Column(
                children: [
                  ListTile(
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
                  ),
                  Image(
                    image: NetworkImage(snapshot.data!.pic),
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
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
                          padding:
                              EdgeInsets.only(left: 20, top: 25, bottom: 15),
                          child: Text(
                            "Comments",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: Color.fromARGB(255, 51, 64, 113)),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                itemCount: 4,
                                itemBuilder: ((context, index) {
                                  return ListTile(
                                    horizontalTitleGap: 6,
                                    contentPadding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    leading: CircleAvatar(
                                        radius: 15,
                                        backgroundImage: NetworkImage(
                                            'https://images.fandango.com/imagerelay/500/0/video.fandango.com/MPX/image/NBCU_Fandango/857/211/thumb_95E77E41-AF48-49E7-A5C4-CB2EFCF088AE.jpg/image.jpg/redesign/static/img/noxSquare.jpg')),
                                    title: Text("Comment $index"),
                                  );
                                }))),
                      ],
                    ),
                  )
                ],
              ),
            );
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

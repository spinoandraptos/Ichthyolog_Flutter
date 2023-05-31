import 'package:flutter/material.dart';
import 'package:ichthyolog/Models/post.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String jwt = '';
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
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Page'),
        backgroundColor: Color.fromARGB(255, 51, 64, 113),
      ),
      body: Text('Postpage'),
    );
  }
}

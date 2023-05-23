import 'package:flutter/material.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import '';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
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
    if (jwt == '') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gallery Page'),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Gallery Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                helpers.logout(jwt, context);
              },
            ),
          ],
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';

class WaitingListPage extends StatefulWidget {
  const WaitingListPage({super.key});
  @override
  WaitingListPageState createState() => WaitingListPageState();
}

class WaitingListPageState extends State<WaitingListPage> {
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
    return Scaffold();
  }
}

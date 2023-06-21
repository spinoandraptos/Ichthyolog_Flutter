import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import '../../Helpers/http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //user fetches post using correct postid
  test('User should fetch post info successfully', () {
    int postid = Random().nextInt(6);
    httpHelpers.viewPostRequest(postid).then((response) {
      expect(response.postid, postid);
    });
  });

  //user fetches post using incorrect postid
  test('User should fail to fetch post info', () {
    int postid = -(Random().nextInt(200));
    httpHelpers.viewPostRequest(postid).then((response) {
      expect(response, Future.error("Post Not Found"));
    });
  });
}

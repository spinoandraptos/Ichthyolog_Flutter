import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:ichthyolog/Helpers/Http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //user fetches post comments using correct postid
  test('User should fetch post comments successfully', () {
    int postid = Random().nextInt(6);
    httpHelpers.viewPostCommentsRequest(postid).then((response) {
      expect(response.isNotEmpty, true);
    });
  });

  //user fetches post comments using incorrect postid
  test('User should fail to fetch post comments', () {
    int postid = -(Random().nextInt(200));
    httpHelpers.viewPostCommentsRequest(postid).then((response) {
      expect(response, Future.error("Comments Not Found"));
    });
  });
}

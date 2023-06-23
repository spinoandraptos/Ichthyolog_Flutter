import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:ichthyolog/Helpers/Http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //user fetches post comments using correct postid
  test('User should fetch post comments successfully', () async {
    int postid = Random().nextInt(6);
    await httpHelpers.viewPostCommentsRequest(postid).then((response) {
      expect(response.isNotEmpty, true);
    });
  });

  //user fetches post comments using incorrect postid
  test('User should fail to fetch post comments', () async {
    int postid = -(Random().nextInt(200));
    await httpHelpers.viewPostCommentsRequest(postid).then((response) async {
      expect(response, Future.error("Comments Not Found"));
    });
  });
}

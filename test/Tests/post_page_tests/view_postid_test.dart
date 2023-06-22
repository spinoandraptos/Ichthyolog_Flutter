import 'package:flutter_test/flutter_test.dart';
import 'package:ichthyolog/Helpers/Http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //user fetches post using correct postid
  test('User should get postid by title', () {
    String title = 'fail';
    httpHelpers.viewPostIdByTitleRequest(title).then((response) {
      print(response);
      expect(response, 1);
    });
  });
}

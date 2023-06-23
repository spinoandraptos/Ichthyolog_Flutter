import 'package:flutter_test/flutter_test.dart';
import 'package:ichthyolog/Helpers/Http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //user fetches post using correct postid
  test('User should get postid by title', () async {
    String title = 'AAA';
    await httpHelpers.viewPostIdByTitleRequest(title).then((response) async {
      expect(response, 5);
    });
  });
}

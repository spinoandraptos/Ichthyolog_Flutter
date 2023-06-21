import 'package:flutter_test/flutter_test.dart';
import '../../Helpers/http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //user fetches all posts
  test('User should fetch all posts successfully', () {
    httpHelpers.viewAllPostsRequest().then((response) {
      expect(response.isNotEmpty, true);
    });
  });
}

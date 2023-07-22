import 'package:flutter_test/flutter_test.dart';
import 'package:ichthyolog/Helpers/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //user fetches all posts
  test('User should edit post info and delete post successfully', () async {
    String jwt = '';
    await httpHelpers
        .loginRequest('tester8@gmail.com', 'tester8', 'Tester8!')
        .then((response) {
      expect(JwtDecoder.decode(response)['username'], 'tester8');
      jwt = response;
    });
    await httpHelpers
        .uploadPostRequest(
            'title',
            'description',
            'sightingLocation',
            DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
            'imageURL',
            jwt,
            'class_',
            'order',
            'family',
            'genus',
            'species')
        .then(
      (response) {
        expect(response, 'Post Uploaded');
      },
    );
    await httpHelpers.viewOwnPostsRequest(jwt).then((response) async {
      await httpHelpers
          .editPostInfoRequest(
              response[0].postid,
              jwt,
              'title1',
              'description1',
              'location1',
              'class_1',
              'order2',
              'family3',
              'genus4',
              'species5')
          .then((response) {
        expect(response, 'Post Edited');
      });
    });
  });
}

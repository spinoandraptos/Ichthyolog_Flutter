import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ichthyolog/Helpers/http.dart';
import 'package:intl/intl.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test('User should perform ID suggestion successfully', () async {
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
          .addIdSuggestionRequest(response[0].postid,
              'Black Eeltail Catfish, Torsat (Plotosus canius)', jwt)
          .then((response) {
        expect(response, 'ID suggestion posted successfully!');
      });
      await httpHelpers
          .loginRequest('ultrakubo123', 'ultrakubo123', 'Kubo123!')
          .then((response) {
        expect(JwtDecoder.decode(response)['username'], 'ultrakubo123');
        jwt = response;
      });
      await httpHelpers
          .viewPostCommentsRequest(response[0].postid)
          .then((response2) async {
        await httpHelpers
            .rejectIdSuggestionRequest(
                response2[0].commentId, jwt, 'test rejection')
            .then((response) {
          expect(response, 'ID Suggestion Rejected');
        });
        await httpHelpers
            .acceptIdSuggestionRequest(
                response[0].postid,
                response2[0].commentId,
                'Black Eeltail Catfish, Torsat (Plotosus canius)',
                jwt)
            .then((response) {
          expect(response, 'ID Suggestion Accepted');
        });
      });
      await httpHelpers
          .deletePostRequest(response[0].postid, jwt)
          .then((response) {
        expect(response, 'Post Deleted');
      });
    });
  });
}

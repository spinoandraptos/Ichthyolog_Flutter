import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ichthyolog/Helpers/http.dart';
import 'package:intl/intl.dart';
import 'dart:math';

void main() {
  final httpHelpers = HttpHelpers();

  test('User should perform ID suggestion successfully', () async {
    String jwt = '';
    int value = Random().nextInt(200) + 100;
    String username = 'tester$value';
    String email = 'tester$value@hotmail.com';
    String password = 'Tester$value!';
    await httpHelpers.signupRequest(username, password, email).then((response) {
      expect(response, 'Signup Successful');
    });
    await httpHelpers.loginRequest(email, username, password).then((response) {
      expect(JwtDecoder.decode(response)['username'], username);
      jwt = response;
    });
    await httpHelpers
        .uploadPostRequest(
            'title$value',
            'description$value',
            'sightingLocation$value',
            DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now()),
            'imageURL$value',
            jwt,
            'class_$value',
            'order$value',
            'family$value',
            'genus$value',
            'species$value')
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
                response2[1].commentId,
                'Black Eeltail Catfish, Torsat (Plotosus canius)',
                jwt)
            .then((response) {
          expect(response, 'ID Suggestion Accepted');
        });
      });
      await httpHelpers.deleteUserRequest(jwt).then((response) {
        expect(response, 'User Deleted');
      });
    });
  });
}

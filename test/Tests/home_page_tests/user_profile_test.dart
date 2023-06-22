import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ichthyolog/Helpers/Http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //logged in user fetches profile info
  test('User should fetch profile info successfully', () {
    String jwt = '';
    httpHelpers.loginRequest('tester9', 'tester9', 'Tester9!').then((response) {
      expect(JwtDecoder.decode(response)['username'], 'tester9');
      jwt = response;
    });
    httpHelpers.viewOwnUserProfileRequest(jwt).then((response) {
      expect(response.username, 'tester9');
    });
  });

  //user fetches profile info without logging in
  test('User should fail to fetch profile info', () {
    String jwt = '';
    httpHelpers.viewOwnUserProfileRequest(jwt).then((response) {
      expect(response, Future.error("User Not Found"));
    });
  });
}

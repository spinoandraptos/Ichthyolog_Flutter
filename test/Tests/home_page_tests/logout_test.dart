import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ichthyolog/Helpers/Http.dart';

void main() {
  final httpHelpers = HttpHelpers();

  //logged in user logs out
  test('User should log out successfully', () {
    String jwt = '';
    httpHelpers
        .loginRequest('tester8@gmail.com', 'tester8@gmail.com', 'Tester8!')
        .then((response) {
      expect(JwtDecoder.decode(response)['username'], 'tester8');
      jwt = response;
    });
    httpHelpers.logoutRequest(jwt).then((response) {
      expect(response, 'Logged out');
    });
  });

  //users logs out without logging in
  test('User should fail to log out', () {
    String jwt = '';
    httpHelpers.logoutRequest(jwt).then((response) {
      expect(response, 'Logout failed');
    });
  });
}

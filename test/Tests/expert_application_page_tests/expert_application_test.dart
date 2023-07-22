import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:ichthyolog/Helpers/http.dart';
import 'dart:math';

void main() {
  final httpHelpers = HttpHelpers();

  test('User should edit comments successfully', () async {
    String jwt = '';
    int userid = 0;
    int value = Random().nextInt(200) + 100;
    int contact = Random().nextInt(9999999) + 10000000;
    String username = 'tester$value';
    String email = 'tester$value@hotmail.com';
    String password = 'Tester$value!';
    await httpHelpers.signupRequest(username, password, email).then((response) {
      expect(response, 'Signup Successful');
    });
    await httpHelpers.loginRequest(email, username, password).then((response) {
      expect(JwtDecoder.decode(response)['username'], username);
      jwt = response;
      userid = JwtDecoder.decode(response)['userid'];
    });
    await httpHelpers
        .addExpertApplicationRequest(userid, 'name', 20, 'male', 'occupation',
            'email', contact, 'credentials', jwt)
        .then((response) {
      expect(response, 'Application added successfully!');
    });
    await httpHelpers
        .viewOwnExpertApplicationsRequest(userid, jwt)
        .then((response) async {
      await httpHelpers
          .loginRequest('ultrakubo123', 'ultrakubo123', 'Kubo123!')
          .then((response) {
        expect(JwtDecoder.decode(response)['username'], 'ultrakubo123');
        jwt = response;
      });
      await httpHelpers
          .rejectExpertApplicationRequest(
              response[0].applicationId, 'test rejection', jwt)
          .then((response) {
        expect(response, 'Application rejected successfully!');
      });
      await httpHelpers
          .deleteExpertApplicationRequest(response[0].applicationId, jwt)
          .then((response) {
        expect(response, 'Application deleted successfully!');
      });
    });
    await httpHelpers.loginRequest(email, username, password).then((response) {
      expect(JwtDecoder.decode(response)['username'], username);
      jwt = response;
      userid = JwtDecoder.decode(response)['userid'];
    });
    await httpHelpers
        .addExpertApplicationRequest(userid, 'name', 20, 'male', 'occupation',
            'email', contact, 'credentials', jwt)
        .then((response) {
      expect(response, 'Application added successfully!');
    });
    await httpHelpers
        .viewOwnExpertApplicationsRequest(userid, jwt)
        .then((response) async {
      await httpHelpers
          .loginRequest('ultrakubo123', 'ultrakubo123', 'Kubo123!')
          .then((response) {
        expect(JwtDecoder.decode(response)['username'], 'ultrakubo123');
        jwt = response;
      });
      await httpHelpers
          .approveExpertApplicationRequest(
              userid, response[0].applicationId, jwt)
          .then((response) {
        expect(response, 'Application approved successfully!');
      });
      await httpHelpers
          .deleteExpertApplicationRequest(response[0].applicationId, jwt)
          .then((response) {
        expect(response, 'Application deleted successfully!');
      });
    });
    await httpHelpers.loginRequest(email, username, password).then((response) {
      expect(JwtDecoder.decode(response)['username'], username);
      jwt = response;
      userid = JwtDecoder.decode(response)['userid'];
    });
    await httpHelpers.deleteUserRequest(jwt).then((response) {
      expect(response, 'User Deleted');
    });
  });
}

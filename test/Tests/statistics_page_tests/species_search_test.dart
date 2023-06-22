import 'dart:math';
import 'package:ichthyolog/Helpers/Http.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test('Test whether search by species shows correct species stats', () async {
    String testerSpecies = Random().nextInt(10000000).toString();
    String testerLocation = Random().nextInt(10000000).toString();
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    late String jwt;
    jwt = await httpHelpers.loginRequest(
        'testgx@gmail.com', 'TestuserGX', 'Gx1887485857!');

    Future testUpload = httpHelpers.uploadPostRequest(
        testerSpecies, '', testerLocation, testerDate, '', jwt, '', '', '', '');
    testUpload.then(
      (response) {
        expect(response, 'Post Uploaded');
      },
    );

    late int testid;
    testid = await httpHelpers.viewPostIdByTitleRequest(testerSpecies);

    Future testVerify = httpHelpers.verifyPostRequest(testid, jwt);
    testVerify.then(
      (response) {
        expect(response, 'Post Verified');
      },
    );

    Future testSearch = httpHelpers.searchSpecies(
        testerSpecies, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['1', testerDate, testerLocation]);
      },
    );

    Future testDelete = httpHelpers.deletePostRequest(testid, jwt);
    testDelete.then(
      (response) {
        expect(response, 'Post Deleted');
      },
    );
  });
}

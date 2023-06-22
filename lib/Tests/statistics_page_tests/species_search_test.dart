import 'dart:math';
import 'package:test/test.dart';
import '../../Helpers/http.dart';
import 'package:intl/intl.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test('Test whether search by species shows correct species stats', () {
    String testerSpecies = Random().nextInt(10000000).toString();
    String testerLocation = Random().nextInt(10000000).toString();
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
    late String jwt;
    httpHelpers
        .loginRequest('testgx@gmail.com', 'TestuserGX', 'Gx1887485857!')
        .then(
      (response) {
        jwt = response;
      },
    );

    Future testUpload = httpHelpers.uploadPostRequest(
        testerSpecies, '', testerLocation, testerDate, '', jwt, '', '', '', '');
    testUpload.then(
      (response) {
        expect(response, 'Post Uploaded');
      },
    );
    expect(testUpload, completes);

    Future testSearch = httpHelpers.searchSpecies(
        testerSpecies, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['1', testerDate, testerLocation]);
      },
    );
    expect(testSearch, completes);
  });
}

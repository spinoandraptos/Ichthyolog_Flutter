import 'package:ichthyolog/Helpers/http.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test('Test whether search by species shows correct species stats', () async {
    String testerSpecies = 'AAA';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    await httpHelpers
        .searchSpecies(testerSpecies, "2000-01-01 00:00:00", testerDate, "")
        .then(
      (response) {
        expect(response, ['1', '2023-06-15T04:49:00.000Z', 'AAAAAAAA']);
      },
    );
  });

  test('Test whether search by species shows correct error message', () async {
    String testerSpecies = 'fail';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    httpHelpers
        .searchSpecies(testerSpecies, "2000-01-01 00:00:00", testerDate, "")
        .then((response) {
      fail('Error was expected, but the future completed successfully.');
    }).catchError((error) {
      expect(error, isA<Error>());
    });
  });
}

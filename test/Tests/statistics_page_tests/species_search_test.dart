import 'package:ichthyolog/Helpers/Http.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test('Test whether search by species shows correct species stats', () async {
    String testerSpecies = 'AAA';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    Future testSearch = httpHelpers.searchSpecies(
        testerSpecies, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['1', testerDate, 'AAAAAAAA']);
      },
    );
  });

  test('Test whether search by species shows correct error message', () async {
    String testerSpecies = 'fail';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    Future testSearch = httpHelpers.searchSpecies(
        testerSpecies, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, 'Species not found! Error 404');
      },
    );
  });
}

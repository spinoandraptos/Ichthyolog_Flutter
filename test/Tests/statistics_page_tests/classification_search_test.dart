import 'package:ichthyolog/Helpers/Http.dart';
import 'package:test/test.dart';
import 'package:intl/intl.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test('Test whether search by classification shows correct species list',
      () async {
    String testerClass = 'Actinopterygii';
    String testOrder = 'Perciformes';
    String testFamily = 'Cichlidae';
    String testGenus = 'Cichla';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    Future testSearch = httpHelpers.searchClassification(testerClass, testOrder,
        testFamily, testGenus, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['Temensis Bass']);
      },
    );
  });

  test('Test whether search by class shows correct species list', () async {
    String testerClass = 'Actinopterygii';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    Future testSearch = httpHelpers.searchClass(
        testerClass, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['Temensis Bass', 'Black fish']);
      },
    );
  });

  test('Test whether search by order shows correct species list', () async {
    String testOrder = 'Perciformes';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    Future testSearch = httpHelpers.searchOrder(
        testOrder, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['Temensis Bass']);
      },
    );
  });

  test('Test whether search by family shows correct species list', () async {
    String testFamily = 'Osphronemidae';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    Future testSearch = httpHelpers.searchFamily(
        testFamily, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['Black fish']);
      },
    );
  });

  test('Test whether search by genus shows correct species list', () async {
    String testGenus = 'Cichla';
    String testerDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());

    Future testSearch = httpHelpers.searchGenus(
        testGenus, "2000-01-01 00:00:00", testerDate, "");
    testSearch.then(
      (response) {
        expect(response, ['Temensis Bass']);
      },
    );
  });
}

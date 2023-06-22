import 'package:ichthyolog/Helpers/Http.dart';
import 'package:test/test.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test(
      'Test whether class catalogue returns correct list of species with count',
      () async {
    Future testSearch = httpHelpers.searchClassCatalogue();
    testSearch.then(
      (response) {
        expect(response, [
          ['Actinopterygii', '1'],
          ['unknown', '10']
        ]);
      },
    );
  });

  test(
      'Test whether order catalogue returns correct list of species with count',
      () async {
    Future testSearch = httpHelpers.searchOrderCatalogue();
    testSearch.then(
      (response) {
        expect(response, [
          ['Perciformes', '1'],
          ['unknown', '10']
        ]);
      },
    );
  });

  test(
      'Test whether family catalogue returns correct list of species with count',
      () async {
    Future testSearch = httpHelpers.searchFamilyCatalogue();
    testSearch.then(
      (response) {
        expect(response, [
          ['Cichlidae', '1'],
          ['unknown', '10']
        ]);
      },
    );
  });

  test(
      'Test whether genus catalogue returns correct list of species with count',
      () async {
    Future testSearch = httpHelpers.searchGenusCatalogue();
    testSearch.then(
      (response) {
        expect(response, [
          ['Cichla', '1'],
          ['unknown', '10']
        ]);
      },
    );
  });
}

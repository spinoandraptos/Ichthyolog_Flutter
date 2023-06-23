import 'package:ichthyolog/Helpers/Http.dart';
import 'package:test/test.dart';

void main() {
  final httpHelpers = HttpHelpers();

  test(
      'Test whether class catalogue returns correct list of species with count',
      () async {
    await httpHelpers.searchClassCatalogue().then(
      (response) {
        expect(response, [
          ['Actinopterygii', '1'],
          ['null', '10']
        ]);
      },
    );
  });

  test(
      'Test whether order catalogue returns correct list of species with count',
      () async {
    await httpHelpers.searchOrderCatalogue().then(
      (response) {
        expect(response, [
          ['Perciformes', '1'],
          ['null', '10']
        ]);
      },
    );
  });

  test(
      'Test whether family catalogue returns correct list of species with count',
      () async {
    await httpHelpers.searchFamilyCatalogue().then(
      (response) {
        expect(response, [
          ['Cichlidae', '1'],
          ['null', '10']
        ]);
      },
    );
  });

  test(
      'Test whether genus catalogue returns correct list of species with count',
      () async {
    await httpHelpers.searchGenusCatalogue().then(
      (response) {
        expect(response, [
          ['Cichla', '1'],
          ['null', '10']
        ]);
      },
    );
  });
}

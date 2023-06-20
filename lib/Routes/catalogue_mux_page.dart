import 'package:flutter/material.dart';
import '../Helpers/http.dart';
import 'catalogue_page.dart';

class CatalogueMuxPage extends StatelessWidget {
  const CatalogueMuxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Column'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
              text: 'Class Catalogue',
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: 'Order Catalogue',
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: 'Family Catalogue',
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
              text: 'Genus Catalogue',
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final httpHelpers = HttpHelpers();
  CustomButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'Class Catalogue') {
          httpHelpers.searchClassCatalogue().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CataloguePage(
                          itemList: value,
                          mux: 'Class',
                        )),
              ));
        } else if (text == 'Order Catalogue') {
          httpHelpers.searchOrderCatalogue().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CataloguePage(
                          itemList: value,
                          mux: 'Order',
                        )),
              ));
        } else if (text == 'Family Catalogue') {
          httpHelpers.searchFamilyCatalogue().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CataloguePage(
                          itemList: value,
                          mux: 'Family',
                        )),
              ));
        } else if (text == 'Genus Catalogue') {
          httpHelpers.searchGenusCatalogue().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CataloguePage(
                          itemList: value,
                          mux: 'Genus',
                        )),
              ));
        }
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
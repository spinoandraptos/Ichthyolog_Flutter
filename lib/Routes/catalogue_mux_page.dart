import 'package:flutter/material.dart';
import '../Helpers/http.dart';
import 'catalogue_page.dart';

class CatalogueMuxPage extends StatelessWidget {
  const CatalogueMuxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 190, 222, 248),
      appBar: AppBar(
        title: const Text('Select a Catalogue'),
        backgroundColor: const Color.fromARGB(255, 70, 88, 152),
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 0.5,
          padding: const EdgeInsets.all(16),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            CustomButton(
              text: 'Class Catalogue',
            ),
            CustomButton(
              text: 'Order Catalogue',
            ),
            CustomButton(
              text: 'Family Catalogue',
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
        textAlign: TextAlign.center,
      ),
    );
  }
}

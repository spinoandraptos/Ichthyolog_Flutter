import 'package:flutter/material.dart';

class CataloguePage extends StatelessWidget {
  final List<List<dynamic>> itemList;

  const CataloguePage({super.key, required this.itemList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary of family with number of species'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7, // Adjust the aspect ratio as desired
        ),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          final item = itemList[index];
          final string1 = item[0].toString();
          final string2 = item[1].toString();

          return Container(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: ListTile(
                title: Text('$string1 ($string2)'),
              ),
            ),
          );
        },
      ),
    );
  }
}

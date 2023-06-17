import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_result_page.dart';
import '../Helpers/Http.dart' as httpHelpers;

class CataloguePage extends StatelessWidget {
  final List<List<dynamic>> itemList;

  const CataloguePage({super.key, required this.itemList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Catalogue'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2, // Adjust the aspect ratio as desired
        ),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          final item = itemList[index];
          final string1 = item[0].toString();
          final string2 = item[1].toString();

          return Card(
            child: ListTile(
                title: Text('$string1 ($string2)',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  httpHelpers
                      .searchFamily(
                          '',
                          '',
                          string1,
                          "2000-01-01 00:00:00",
                          DateFormat("yyyy-MM-dd hh:mm:ss")
                              .format(DateTime.now()),
                          '')
                      .then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchResultPage(
                                      dataList: value,
                                      startTime: "2000-01-01 00:00:00",
                                      endTime: DateFormat("yyyy-MM-dd hh:mm:ss")
                                          .format(DateTime.now()),
                                      sightinglocation: '',
                                    )),
                          ));
                }),
          );
        },
      ),
    );
  }
}

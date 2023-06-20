import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'search_result_page.dart';
import '../Helpers/Http.dart' as httpHelpers;

class CataloguePage extends StatelessWidget {
  final List<List<dynamic>> itemList;
  final String mux;
  const CataloguePage({super.key, required this.itemList, required this.mux});

  Function chooseSearch(String mux) {
    switch (mux) {
      case 'Family':
        return httpHelpers.searchFamily;
      case 'Genus':
        return httpHelpers.searchGenus;
      case 'Order':
        return httpHelpers.searchOrder;
      case 'Class':
        return httpHelpers.searchClass;
      default:
        return httpHelpers.searchClass;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$mux Catalogue'),
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
                title: Text(
                  '$string1 ($string2)',
                ),
                onTap: () {
                  chooseSearch(mux)
                      .call(
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

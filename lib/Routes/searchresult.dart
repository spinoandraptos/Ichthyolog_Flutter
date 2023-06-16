import 'package:flutter/material.dart';
import '../Helpers/Http.dart' as http;
import 'statsresult.dart';

class SearchResultPage extends StatelessWidget {
  final List<String> dataList;
  final String startTime;
  final String endTime;
  final String sightinglocation;

  const SearchResultPage({
    Key? key,
    required this.dataList,
    required this.startTime,
    required this.endTime,
    required this.sightinglocation,
  }) : super(key: key);

  void showSpeciesResult(BuildContext context, String species) {
    try {
      http
          .searchSpecies(species, startTime, endTime, sightinglocation)
          .then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatsResultPage(
              dataList: value,
              species: species,
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final data = dataList[index];

          return ListTile(
            title: Text(data),
            onTap: () {
              showSpeciesResult(context, data); // Pass the context here
            },
          );
        },
      ),
    );
  }
}

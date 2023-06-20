import 'package:flutter/material.dart';
import '../Helpers/http.dart' as http;
import 'stats_result_page.dart';

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
          if (index == 0) {
            return Column(
              children: [
                Text(
                  '${dataList.length} results found',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  title: Text(
                    data,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    showSpeciesResult(context, data); // Pass the context here
                  },
                  trailing: const Icon(Icons.arrow_forward),
                  //leave a line between each list tile
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return ListTile(
              title: Text(
                data,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                showSpeciesResult(context, data); // Pass the context here
              },
              trailing: const Icon(Icons.arrow_forward),
              //leave a line between each list tile
              shape: const RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

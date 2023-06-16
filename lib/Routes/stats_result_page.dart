import 'package:flutter/material.dart';

class StatsResultPage extends StatelessWidget {
  final List<String> dataList;
  final String species;
  const StatsResultPage(
      {super.key, required this.dataList, required this.species});

  @override
  Widget build(BuildContext context) {
    //remove the last 8 characters of  dataList[1] and split the remaining string by the character 'T'
    dataList[1] = dataList[1].substring(0, dataList[1].length - 8);
    List<String> dateTime = dataList[1].split('T');
    String date = dateTime[0];
    String time = dateTime[1];

    return Scaffold(
        appBar: AppBar(
          title: Text('$species Stats'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  '$species Stats',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  'Total Sightings: ${dataList[0]}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  'Last seen on: $date at $time',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: Text(
                  'Last seen location: ${dataList[2]}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}

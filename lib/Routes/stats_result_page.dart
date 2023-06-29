import 'package:flutter/material.dart';

class StatsResultPage extends StatefulWidget {
  final List<String> dataList;
  final String species;

  const StatsResultPage({
    Key? key,
    required this.dataList,
    required this.species,
  }) : super(key: key);

  @override
  _StatsResultPageState createState() => _StatsResultPageState();
}

class _StatsResultPageState extends State<StatsResultPage> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.dataList[1] =
        widget.dataList[1].substring(0, widget.dataList[1].length - 8);
    List<String> dateTime = widget.dataList[1].split('T');
    String date = dateTime[0];
    String time = dateTime[1];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.species} Stats'),
        backgroundColor: const Color.fromARGB(255, 51, 64, 113),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                widget.species,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                'Total Sightings: ${widget.dataList[0]}',
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
                'Last seen location: ${widget.dataList[2]}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 400,
              child: PageView(
                controller: _pageController,
                children: [
                  _buildStatsBox('Sightings last 3 days'),
                  _buildStatsBox('Sightings last 7 days'),
                  _buildStatsBox('Sightings last month'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBox(String title) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../Helpers/Http.dart';
import 'package:fl_chart/fl_chart.dart';

class StatsResultPage extends StatefulWidget {
  final List<String> dataList;
  final String species;

  const StatsResultPage({
    Key? key,
    required this.dataList,
    required this.species,
  }) : super(key: key);

  @override
  StatsResultPageState createState() => StatsResultPageState();
}

class StatsResultPageState extends State<StatsResultPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final httpHelpers = HttpHelpers();

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
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
      backgroundColor: const Color.fromARGB(255, 190, 222, 248),
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
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, (1 - _animation.value) * 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          width: 3,
                        ),
                        color: const Color.fromARGB(255, 134, 195, 246),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Flexible(
                        child: Text(
                          widget.species,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, (1 - _animation.value) * 20),
                    child: StatsContainer(
                      icon: Icons.visibility,
                      text: 'Total sightings: ${widget.dataList[0]}',
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, (1 - _animation.value) * 20),
                    child: StatsContainer(
                      icon: Icons.calendar_month_outlined,
                      text: 'Last seen on $date at $time',
                    ),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: Transform.translate(
                    offset: Offset(0.0, (1 - _animation.value) * 20),
                    child: StatsContainer(
                      icon: Icons.location_on_outlined,
                      text: 'Last seen location: ${widget.dataList[2]}',
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 500,
              child: FutureBuilder<List<List<List<String>>>>(
                future: httpHelpers.speciesCountStats(widget.species),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final speciesCount = snapshot.data;
                    return AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _animation.value,
                          child: Transform.translate(
                            offset: Offset(0.0, (1 - _animation.value) * 20),
                            child: PageView(
                              controller: _pageController,
                              children: [
                                _buildStatsBox('Sightings last 24 hours',
                                    speciesCount![0]),
                                _buildStatsBox(
                                    'Sightings last 7 days', speciesCount[1]),
                                _buildStatsBox(
                                    'Sightings last month', speciesCount[2]),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBox(String title, List<List<String>> data) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: BarGraph(data: data),
            ),
          ],
        ),
      ),
    );
  }
}

class StatsContainer extends StatelessWidget {
  final IconData icon;
  final String text;

  const StatsContainer({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 134, 195, 246),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IndividualBar {
  final String time;
  final int count;

  IndividualBar({required this.time, required this.count});
}

class BarData {
  final List<List<String>> data;
  BarData({required this.data});

  List<IndividualBar> barData = [];

  void initializeBarData() {
    for (int i = 0; i < data.length; i++) {
      barData
          .add(IndividualBar(time: data[i][0], count: int.parse(data[i][1])));
    }
  }
}

class BarGraph extends StatelessWidget {
  final List<List<String>> data;
  const BarGraph({Key? key, required this.data}) : super(key: key);

  int getMaxY() {
    int max = 0;
    for (int i = 0; i < data.length; i++) {
      if (int.parse(data[i][1]) > max) {
        max = int.parse(data[i][1]);
      }
    }
    return max + 10;
  }

  @override
  Widget build(BuildContext context) {
    BarData barData = BarData(data: data);
    barData.initializeBarData();
    return BarChart(BarChartData(
      maxY: getMaxY().toDouble(),
      minY: 0,
      barGroups: barData.barData
          .map(
            (data) => BarChartGroupData(
              x: barData.barData.indexOf(data),
              barRods: [
                BarChartRodData(
                  toY: data.count.toDouble(),
                )
              ],
            ),
          )
          .toList(),
    ));
  }
}

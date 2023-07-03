import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'date_time_picker.dart';
import 'Stepper.dart';
import 'stats_result_page.dart';
import 'search_result_page.dart';
import 'catalogue_page.dart';
import 'catalogue_mux_page.dart';
import 'package:flutter/widgets.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text('No data found. Please try again.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
      ),
    );
  }
}

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  String mux = '';
  String jwt = '';
  String date1 = '2000-01-01';
  String time1 = '00:00:00';
  String date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String time2 = DateFormat("hh:mm:ss").format(DateTime.now());
  String species = '';
  String sightingLocation = '';
  String class_ = '';
  String order = '';
  String family = '';
  String genus = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();
  final speciesController = TextEditingController();
  final locationController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _animationController, curve: Curves.easeInOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _clearSearchInputs() {
    setState(() {
      date1 = '2000-01-01';
      time1 = '00:00:00';
      date2 = DateFormat("yyyy-MM-dd").format(DateTime.now());
      time2 = DateFormat("hh:mm:ss").format(DateTime.now());
      species = '';
      sightingLocation = '';
      class_ = '';
      order = '';
      family = '';
      genus = '';
      speciesController.clear();
      locationController.clear();
    });
  }

  void _search(
      String date1,
      String time1,
      String date2,
      String time2,
      String location,
      String species,
      String class_,
      String order,
      String family,
      String genus,
      String jwt) {
    // Insert HTTP search query here with given parameters
    // Return a result page with approriate contents
    if (mux == 'species') {
      httpHelpers
          .searchSpecies(
        species,
        '$date1 $time1',
        '$date2 $time2',
        location,
      )
          .then((value) {
        if (value.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatsResultPage(
                dataList: value,
                species: species,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ErrorPage(),
            ),
          );
        }
      }).catchError((error) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ErrorPage(),
          ),
        );
      });
    } else {
      httpHelpers
          .searchClassification(
        class_,
        order,
        family,
        genus,
        '$date1 $time1',
        '$date2 $time2',
        location,
      )
          .then((value) {
        if (value.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResultPage(
                dataList: value,
                startTime: '$date1 $time1',
                endTime: '$date2 $time2',
                sightinglocation: location,
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ErrorPage(),
            ),
          );
        }
      }).catchError((error) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ErrorPage(),
          ),
        );
      });
    }
  }

  void showCatalogue(String mux) {
    try {
      httpHelpers.searchFamilyCatalogue().then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CataloguePage(
              itemList: value,
              mux: mux,
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Widget blueBox(String text, Widget widget) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 82, 108, 175),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10),
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 51, 64, 113)),
              textAlign: TextAlign.left,
            ),
          ),
          widget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (mux == '') {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 190, 222, 248),
        appBar: AppBar(
          title: const Text('Search Statistics'),
          backgroundColor: const Color.fromARGB(255, 65, 90, 181),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 1.6,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: const Offset(0, 0),
                      ).animate(_animationController);

                      final fadeAnimation = Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(_animationController);

                      return SlideTransition(
                        position: slideAnimation,
                        child: Opacity(
                          opacity: fadeAnimation.value,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mux = 'species';
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<CircleBorder>(
                                const CircleBorder(),
                              ),
                            ),
                            child: const Text(
                              'Species',
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: const Offset(0, 0),
                      ).animate(_animationController);

                      final fadeAnimation = Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(_animationController);

                      return SlideTransition(
                        position: slideAnimation,
                        child: Opacity(
                          opacity: fadeAnimation.value,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                mux = 'classification';
                              });
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<CircleBorder>(
                                  const CircleBorder()),
                            ),
                            child: const Text(
                              'Classification',
                              style: TextStyle(fontSize: 35),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      final slideAnimation = Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: const Offset(0, 0),
                      ).animate(_animationController);

                      final fadeAnimation = Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(_animationController);

                      return SlideTransition(
                        position: slideAnimation,
                        child: Opacity(
                          opacity: fadeAnimation.value,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CatalogueMuxPage(),
                                ),
                              );
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<CircleBorder>(
                                const CircleBorder(),
                              ),
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.all(10)),
                            ),
                            child: const Text(
                              'Species\nCatalogue',
                              style: TextStyle(fontSize: 40),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )),
      );
    } else {
      return Scaffold(
          backgroundColor: const Color.fromARGB(255, 190, 222, 248),
          appBar: AppBar(
            title: const Text('Search Statistics'),
            backgroundColor: const Color.fromARGB(255, 65, 90, 181),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              (mux == 'species')
                  ? blueBox(
                      "1. Choose species",
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 15, right: 15),
                        child: TextFormField(
                          controller: speciesController,
                          decoration: const InputDecoration(
                            hintText: 'Enter species name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              species = value;
                            });
                          },
                        ),
                      ))
                  : blueBox(
                      "1. Choose classification",
                      Column(
                        children: [
                          Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  top: 10, left: 12, right: 12, bottom: 10),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          content: SizedBox(
                                            height: 500,
                                            width: 500,
                                            child: SpeciesStepper(
                                              classCallback: classCallback,
                                              orderCallback: orderCallback,
                                              familyCallback: familyCallback,
                                              genusCallback: genusCallback,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                                child: const Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        );
                                      });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 102, 154, 217)),
                                child: const Text('Choose classification',
                                    style: TextStyle(fontSize: 16)),
                              )),
                          Container(
                              margin: const EdgeInsets.only(bottom: 5),
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              alignment: Alignment.center,
                              width: double.infinity,
                              color: const Color.fromARGB(255, 224, 228, 238),
                              child: Text(
                                  'Class: $class_, Order: $order, Family: $family, Genus: $genus')),
                        ],
                      )),
              blueBox(
                  "2. Choose sighting location",
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 16),
                      child: TextFormField(
                        controller: locationController,
                        decoration: const InputDecoration(
                          hintText: 'Enter the location of sighting',
                        ),
                        onChanged: (value) {
                          setState(() {
                            sightingLocation = value;
                          });
                        },
                      ))),
              blueBox(
                  "3. Choose range of sighting time",
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 25,
                        color: const Color.fromARGB(255, 190, 222, 248),
                        child: Text(
                          "From: $date1 $time1",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        ),
                      ),
                      PickerDateTimeRoute(
                        dateCallback: dateCallback1,
                        timeCallback: timeCallback1,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 25,
                        color: const Color.fromARGB(255, 190, 222, 248),
                        child: (date2 == '' && time2 == '')
                            ? Text(
                                'To: ${DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now())}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )
                            : Text(
                                "To: $date2 $time2",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              ),
                      ),
                      PickerDateTimeRoute(
                        dateCallback: dateCallback2,
                        timeCallback: timeCallback2,
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _search(date1, time1, date2, time2, sightingLocation,
                          species, class_, order, family, genus, jwt);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 80, 170, 121)),
                    child: const Text('Search', style: TextStyle(fontSize: 30)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _clearSearchInputs();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 170, 80, 80)),
                    child: const Text('Clear', style: TextStyle(fontSize: 30)),
                  )
                ],
              ),
            ]),
          ));
    }
  }

  timeCallback1(newValue) {
    setState(() {
      time1 = newValue;
    });
  }

  dateCallback1(newValue) {
    setState(() {
      date1 = newValue;
    });
  }

  timeCallback2(newValue) {
    setState(() {
      time2 = newValue;
    });
  }

  dateCallback2(newValue) {
    setState(() {
      date2 = newValue;
    });
  }

  classCallback(newValue) {
    setState(() {
      class_ = newValue;
    });
  }

  orderCallback(newValue) {
    setState(() {
      order = newValue;
    });
  }

  familyCallback(newValue) {
    setState(() {
      family = newValue;
    });
  }

  genusCallback(newValue) {
    setState(() {
      genus = newValue;
    });
  }
}

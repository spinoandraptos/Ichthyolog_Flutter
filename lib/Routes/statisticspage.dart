import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import 'datetimepicker.dart';
import 'Stepper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String jwt = '';
  String date1 = '';
  String time1 = '';
  String date2 = '';
  String time2 = '';
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

  void _clearSearchInputs() {
    setState(() {
      date1 = '';
      time1 = '';
      date2 = '';
      time2 = '';
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

    Fluttertoast.showToast(
        msg: "Search query sent",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 51, 64, 113),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Page'),
        backgroundColor: const Color.fromARGB(255, 51, 64, 113),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 15, right: 15),
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
                  ),
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
                      )),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 45,
                        color: const Color.fromARGB(255, 224, 228, 238),
                        child: (date1 == '' && time1 == '')
                            ? const Text(
                                'From:',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )
                            : Text(
                                "From: $date1 $time1",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              ),
                      ),
                    ],
                  ),
                  PickerDateTimeRoute(
                    dateCallback: dateCallback1,
                    timeCallback: timeCallback1,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 45,
                        color: const Color.fromARGB(255, 224, 228, 238),
                        child: (date2 == '' && time2 == '')
                            ? Text(
                                'To: ${DateFormat("yyyy-mm-dd hh:mm:ss").format(DateTime.now())}',
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
                    ],
                  ),
                  PickerDateTimeRoute(
                    dateCallback: dateCallback2,
                    timeCallback: timeCallback2,
                  ),
                  Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      alignment: Alignment.center,
                      width: double.infinity,
                      color: const Color.fromARGB(255, 224, 228, 238),
                      child: Text(
                          'Class: $class_, Order: $order, Family: $family, Genus: $genus')),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(
                              top: 6, left: 12, right: 12, bottom: 10),
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
                                backgroundColor:
                                    const Color.fromARGB(255, 102, 154, 217)),
                            child: const Text('Choose classification',
                                style: TextStyle(fontSize: 16)),
                          )),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 6, right: 12, bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              _search(
                                  date1,
                                  time1,
                                  date2,
                                  time2,
                                  sightingLocation,
                                  species,
                                  class_,
                                  order,
                                  family,
                                  genus,
                                  jwt);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 80, 170, 121)),
                            child: const Text('Search',
                                style: TextStyle(fontSize: 18)),
                          )),
                      Container(
                          margin: const EdgeInsets.only(
                              top: 6, right: 12, bottom: 10),
                          child: ElevatedButton(
                            onPressed: () =>
                                setState(() => _clearSearchInputs()),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 170, 80, 80)),
                            child: const Text('Clear',
                                style: TextStyle(fontSize: 18)),
                          ))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
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

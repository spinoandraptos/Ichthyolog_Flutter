import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}

class PickerDateTimeRoute extends StatefulWidget {
  const PickerDateTimeRoute({Key? key}) : super(key: key);

  @override
  PickerDateTimeRouteState createState() => PickerDateTimeRouteState();

  String getDateAndTime() {
    return PickerDateTimeRouteState().selectedDateAndTime();
  }
}

class PickerDateTimeRouteState extends State<PickerDateTimeRoute> {
  String date = "";
  String time = "";

  String selectedDateAndTime() {
    debugPrint("DATE: $date $time");
    return "$date $time";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 45,
          color: Colors.grey[300],
          child: Text("$date $time"),
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 70, 88, 152),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 30)),
            child: const Text("Select date of sighting",
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              showDialogPicker(context);
            },
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromARGB(255, 70, 88, 152),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 30)),
            child: const Text("select time of sighting",
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              showDialogTimePicker(context);
            },
          ),
        )
      ],
    );
  }

  Future<void> showDialogPicker(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      helpText: 'Select the date of sighting',
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // primary: MyColors.primary,
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            //.dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    if (selectedDate != null) {
      setState(() {
        date =
            Utils.getFormattedDateSimple(selectedDate.millisecondsSinceEpoch);
        debugPrint("Date: $date");
      });
    }
  }

  Future<void> showDialogTimePicker(BuildContext context) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // primary: MyColors.primary,
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            //.dialogBackgroundColor:Colors.blue[900],
          ),
          child: child!,
        );
      },
    );
    if (selectedTime != null) {
      setState(() {
        time = "${selectedTime.hour}:${selectedTime.minute}:00";
        debugPrint("Time: $time");
      });
    }
  }
}

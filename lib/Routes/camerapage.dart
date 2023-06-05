import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'datetimepicker.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import 'package:intl/intl.dart';
import 'gallerypage.dart';
import 'Stepper.dart';

class Utils {
  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  File? image;
  String jwt = '';
  String date = "";
  String time = "";
  String title = '';
  String description = '';
  String sightingLocation = '';
  String class_ = '';
  String order = '';
  String family = '';
  String genus = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();

  @override
  void initState() {
    super.initState();
    helpers.checkJwt().then((token) {
      if (token == '') {
        setState(() {
          jwt = '';
        });
      } else {
        setState(() {
          jwt = token;
        });
      }
    });
  }

  // ignore: unused_element
  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Post a sighting'),
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
                      padding:
                          const EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter species name',
                        ),
                        onChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter species description',
                          ),
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                        )),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 16),
                        child: TextFormField(
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
                          child: (date == '' && time == '')
                              ? Text(
                                  'Sighting timing: ${DateFormat("yyyy-mm-dd hh:mm:ss").format(DateTime.now())}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 51, 64, 113)),
                                )
                              : Text(
                                  "Sighting timing: $date $time",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 51, 64, 113)),
                                ),
                        ),
                      ],
                    ),
                    PickerDateTimeRoute(
                      dateCallback: dateCallback,
                      timeCallback: timeCallback,
                    ),
                    Image.file(image!),
                    Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        padding: EdgeInsets.only(left: 12, right: 12),
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
                                            class_: class_,
                                            order: order,
                                            family: family,
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
                              child: const Text('Add classification',
                                  style: TextStyle(fontSize: 16)),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 6, right: 12, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                _uploadPost(
                                  title,
                                  description,
                                  sightingLocation,
                                  "$date $time",
                                  jwt,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 80, 170, 121)),
                              child: const Text('Upload',
                                  style: TextStyle(fontSize: 18)),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 6, right: 12, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () => setState(() => image = null),
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
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Post an image'),
            backgroundColor: const Color.fromARGB(255, 51, 64, 113),
          ),
          body: SingleChildScrollView(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 2 / 7),
                  const Icon(
                    Icons.photo,
                    size: 110,
                    color: Color.fromARGB(255, 51, 64, 113),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _takePhoto(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 74, 112, 178),
                    ),
                    child: const Text('Take Photo'),
                  ),
                  ElevatedButton(
                    onPressed: _selectFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 87, 131, 206),
                    ),
                    child: const Text('Select from Gallery'),
                  ),
                ])
              ]))));
    }
  }

  void _uploadPost(
    String title,
    String description,
    String sightingLocation,
    String sightingTime,
    String jwt,
  ) async {
    final key = const Uuid().v4();
    final file = AWSFile.fromPath(image!.path);

    try {
      final result = Amplify.Storage.uploadFile(
        key: key,
        localFile: file,
        options: const StorageUploadFileOptions(
          accessLevel: StorageAccessLevel.guest,
        ),
      );
      print('Upload result: $result');

      //send description and other post information to database
      httpHelpers
          .uploadPostRequest(
              title,
              description,
              sightingLocation,
              sightingTime,
              "https://ichthyolog175756-dev.s3.ap-southeast-1.amazonaws.com/public/$key",
              jwt,
              1,
              1)
          .then((String response) {
        if (response == 'Post Uploaded') {
          Fluttertoast.showToast(
            msg: 'Post uploaded successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const GalleryPage()),
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Post upload failed!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _takePhoto(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectFromGallery() async {
    _takePhoto(ImageSource.gallery);
  }

  timeCallback(newValue) {
    setState(() {
      time = newValue;
    });
  }

  dateCallback(newValue) {
    setState(() {
      date = newValue;
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

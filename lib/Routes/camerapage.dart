import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'datetimepicker.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import 'package:intl/intl.dart';
import 'gallerypage.dart';

class Utils {
  static String getFormattedDateSimple(int time) {
    DateFormat newFormat = DateFormat("yyyy-MM-dd");
    return newFormat.format(DateTime.fromMillisecondsSinceEpoch(time));
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  String date = "";
  String time = "";
  String _title = '';
  String _description = '';
  String sightingLocation = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();
  String jwt = '';

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

  void _uploadPost(
    String title,
    String description,
    String sightingLocation,
    String sightingTime,
    String jwt,
  ) async {
    final key = const Uuid().v4();
    final file = AWSFile.fromPath(_image!.path);

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
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _selectFromGallery() async {
    _takePhoto(ImageSource.gallery);
  }

  // ignore: unused_element
  @override
  Widget build(BuildContext context) {
    if (_image != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Post a sighting'),
          backgroundColor: Color.fromARGB(255, 51, 64, 113),
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
                      padding: EdgeInsets.only(top: 5, left: 15, right: 15),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Enter species name',
                        ),
                        onChanged: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter species description',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          },
                        )),
                    Padding(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 18),
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
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: 45,
                          color: Color.fromARGB(255, 224, 228, 238),
                          child: Text(
                            "Sighting timing: $date $time",
                            style: TextStyle(
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
                    Image.file(_image!),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                            margin:
                                EdgeInsets.only(top: 6, right: 12, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () {
                                _uploadPost(
                                  _title,
                                  _description,
                                  sightingLocation,
                                  "$date $time",
                                  jwt,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 80, 170, 121)),
                              child: const Text('Upload',
                                  style: TextStyle(fontSize: 18)),
                            )),
                        Container(
                            margin:
                                EdgeInsets.only(top: 6, right: 12, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () => setState(() => _image = null),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 170, 80, 80)),
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
            backgroundColor: Color.fromARGB(255, 51, 64, 113),
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
                      backgroundColor: Color.fromARGB(255, 74, 112, 178),
                    ),
                    child: const Text('Take Photo'),
                  ),
                  ElevatedButton(
                    onPressed: _selectFromGallery,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 87, 131, 206),
                    ),
                    child: const Text('Select from Gallery'),
                  ),
                ])
              ]))));
    }
  }
}

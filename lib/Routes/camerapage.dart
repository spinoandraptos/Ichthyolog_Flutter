import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Helpers/Helper.dart';
import '../Helpers/Http.dart';
import 'package:intl/intl.dart';
import 'datetimepicker.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  String _title = '';
  String _description = '';
  String sightingLocation = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();
  String jwt = '';
  final dateTimePicker = PickerDateTimeRoute();

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
      )
          .then((String response) {
        if (response == 'Post Uploaded') {
          Fluttertoast.showToast(
            msg: 'Post uploaded successfully!',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post an image'),
        backgroundColor: Color.fromARGB(255, 70, 88, 152),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image != null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter a title',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _title = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter a description',
                          ),
                          onChanged: (value) {
                            setState(() {
                              _description = value;
                            });
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter the location of sighting',
                          ),
                          onChanged: (value) {
                            setState(() {
                              sightingLocation = value;
                            });
                          },
                        ),
                        dateTimePicker,
                        ElevatedButton(
                          onPressed: () {
                            debugPrint(dateTimePicker.getDateAndTime());
                            _uploadPost(
                              _title,
                              _description,
                              sightingLocation,
                              dateTimePicker.getDateAndTime(),
                              jwt,
                            );
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 70, 88, 152)),
                          ),
                          child: const Text('Upload'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => setState(() => _image = null),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(255, 70, 88, 152)),
                          ),
                          child: const Text('Clear'),
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 40,
                    ),
              _image != null
                  ? Image.file(_image!)
                  : const Icon(Icons.photo, size: 80),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _takePhoto(ImageSource.camera),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 70, 88, 152)),
                ),
                child: const Text('Take Photo'),
              ),
              ElevatedButton(
                onPressed: _selectFromGallery,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 70, 88, 152)),
                ),
                child: const Text('Select from Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

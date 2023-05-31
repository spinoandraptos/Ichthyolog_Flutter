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
  int _userid = 0;
  String _username = '';
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
    httpHelpers.viewUserRequest(jwt).then((user) {
      setState(() {
        _userid = user.userid;
        _username = user.username;
      });
    });
  }

  void _uploadPost(
    int userid,
    String username,
    String title,
    String description,
    String uploadTime,
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
        userid,
        username,
        title,
        description,
        uploadTime,
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
        backgroundColor: Color.fromARGB(255, 51, 64, 113),
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
                            _uploadPost(
                              _userid,
                              _username,
                              _title,
                              _description,
                              DateFormat("yyyy-mm-dd hh:mm:ss")
                                  .format(DateTime.now().toUtc()),
                              sightingLocation,
                              dateTimePicker.getDateAndTime(),
                              jwt,
                            );
                          },
                          child: const Text('Upload'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => setState(() => _image = null),
                          child: const Text('Clear'),
                        ),
                      ],
                    )
                  : const SizedBox(),
              _image != null
                  ? Image.file(_image!)
                  : const Icon(Icons.photo, size: 80),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _takePhoto(ImageSource.camera),
                child: const Text('Take Photo'),
                style: ButtonStyle(),
              ),
              ElevatedButton(
                onPressed: _selectFromGallery,
                child: const Text('Select from Gallery'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

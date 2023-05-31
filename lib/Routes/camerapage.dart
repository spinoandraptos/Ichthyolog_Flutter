import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _image;
  Future<String> _takePhoto(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      final savedFile = await GallerySaver.saveImage(_image!.path);
      print('Photo saved: $savedFile');

      final key = const Uuid().v4();
      final file = AWSFile.fromPath(_image!.path);
      try {
        final result = Amplify.Storage.uploadFile(
          key: key,
          localFile: file,
          options: const StorageUploadFileOptions(
            accessLevel: StorageAccessLevel.guest,
          ),
        ).result;

        Fluttertoast.showToast(
          msg: 'Image uploaded successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        return key;
      } catch (error) {
        print(error);
      }
    }
    return "Image not found";
  }

  Future<void> _selectFromGallery() async {
    _takePhoto(ImageSource.gallery);
  }

  // ignore: unused_element
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo'),
        backgroundColor: Color.fromARGB(255, 51, 64, 113),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
    );
  }
}

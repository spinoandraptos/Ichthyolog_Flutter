import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'date_time_picker.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import '../Helpers/standard_widgets.dart';
import '../Models/species.dart';
import 'package:intl/intl.dart';
import 'gallery_page.dart';
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
  String date = '';
  String time = '';
  String title = '';
  String description = '';
  String sightingLocation = '';
  String class_ = '';
  String order = '';
  String family = '';
  String genus = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  List<String> species = <String>[];
  List<String> locations = <String>[
    'Classified',
    'Singapore',
    'Strait of Singapore',
    'Singapore straits off raffles lighthouse',
    'Singapore straits off Pulau Bukom',
    'Singapore straits off Pulau Hantu',
    'Singapore straits off St. John’s island ',
    'Singapore straits off Pulau Sudong',
    'Singapore straits off Pulau Satumu',
    'Singapore straits off Terumbu berkas',
    'Singapore straits off Terumbu Pempang Tengah',
    'Singapore straits off Jurong Island',
    'Singapore straits off Sentosa',
    'Straits of Johor',
    'Johor Straits off Tuas',
    'Johor Straits off Sembawang',
    'Johor Straits off Changi',
    'Johor Straits off Pulau Ubin',
    'Johor Straits off Pulau Tekong',
    'Tuas',
    'Raffles Marina',
    'Kranji Reservoir ',
    'Kranji Dam',
    'Sembawang jetty',
    'Sembawang Park',
    'Lim Chu Kang Area',
    'Woodlands Waterfront',
    'Yishun Dam',
    'Lower Seletar Reservoir (Rowers’ Bay)',
    'Lower Seletar Reservoir',
    'Punggol Waterfront',
    'Punggol Point',
    'Punggol Jetty',
    'Lorong Halus',
    'Punggol-Serangoon Reservoir',
    'Punggol Reservoir',
    'Coney East Dam',
    'Lower Peirce Reservoir',
    'Upper Seletar Reservoir',
    'Macritchie Reservoir',
    'Pasir Ris Park',
    'Changi Boardwalk',
    'Changi Beach Park',
    'Pulau Ubin',
    'NSRCC Canal',
    'East Coast Park',
    'East Coast Park (Bedok Jetty)',
    'East Coast Park (Twin Jetty)',
    'East Coast Park (White Jetty)',
    'Bedok Reservoir',
    'Kallang River',
    'Kallang River (Marina Reservoir)',
    'Kallang River (Kolam Ayer)',
    'Kallang River (Rochor)',
    'Kallang River (Macpherson)',
    'Marina Barrage',
    'Marina South Pier',
    'Marina South',
    'West Coast Park',
    'Penjuru River',
    'Pandan River',
    'Pandan Reservoir ',
    'Kent Ridge Park',
  ];

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
    for (var record in singaporeRecords) {
      species.add(record.commonNames);
    }
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
                    selectableTextForm(
                        titleController,
                        'Enter species name',
                        const Icon(
                          Icons.phishing,
                          color: Color.fromARGB(255, 51, 64, 113),
                        ),
                        species,
                        titleCallback),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 12, right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 225, 235, 248),
                            borderRadius: BorderRadius.circular(16)),
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.description,
                                color: Color.fromARGB(255, 51, 64, 113)),
                            border: InputBorder.none,
                            labelText: 'Enter species description',
                          ),
                          onChanged: (value) {
                            setState(() {
                              description = value;
                            });
                          },
                        )),
                    selectableTextForm(
                        locationController,
                        'Enter the location of sighting',
                        const Icon(
                          Icons.pin_drop,
                          color: Color.fromARGB(255, 51, 64, 113),
                        ),
                        locations,
                        locationCallback),
                    Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 45,
                        child: Wrap(children: [
                          const Text(
                            'Sighting timing:  ',
                            style: TextStyle(fontSize: 16),
                          ),
                          (date == '' && time == '')
                              ? Text(
                                  DateFormat("yyyy-MM-dd hh:mm:ss")
                                      .format(DateTime.now()),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 51, 64, 113),
                                      fontSize: 16),
                                )
                              : Text(
                                  "$date $time",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 51, 64, 113),
                                      fontSize: 16),
                                ),
                        ])),
                    PickerDateTimeRoute(
                      dateCallback: dateCallback,
                      timeCallback: timeCallback,
                    ),
                    Image.file(image!),
                    Container(
                        margin: const EdgeInsets.only(bottom: 7, top: 15),
                        padding: const EdgeInsets.only(left: 12, right: 12),
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: Column(children: [
                          Wrap(
                            children: [
                              const Text(
                                'Class: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113),
                                    fontSize: 14),
                              ),
                              Text(
                                class_ == ''
                                    ? '[Choose below]   '
                                    : '$class_   ',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const Text(
                                'Order: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113),
                                    fontSize: 14),
                              ),
                              Text(
                                order == '' ? '[Choose below]' : order,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          Wrap(
                            children: [
                              const Text(
                                'Family: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113),
                                    fontSize: 14),
                              ),
                              Text(
                                family == ''
                                    ? '[Choose below]   '
                                    : '$family   ',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const Text(
                                'Genus: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113),
                                    fontSize: 14),
                              ),
                              Text(
                                genus == '' ? '[Choose below]' : genus,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ])),
                    Wrap(
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
                                          content: StatefulBuilder(
                                        builder: (context, setState) {
                                          return SpeciesStepper(
                                            classCallback: classCallback,
                                            orderCallback: orderCallback,
                                            familyCallback: familyCallback,
                                            genusCallback: genusCallback,
                                          );
                                        },
                                      ));
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
                                    class_,
                                    order,
                                    family,
                                    genus);
                                setState(() {
                                  image = null;
                                  class_ = '';
                                  order = '';
                                  family = '';
                                  genus = '';
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 80, 170, 121)),
                              child: const Text('Upload',
                                  style: TextStyle(fontSize: 17)),
                            )),
                        Container(
                            margin: const EdgeInsets.only(
                                top: 6, right: 12, bottom: 10),
                            child: ElevatedButton(
                              onPressed: () => setState(() {
                                image = null;
                                class_ = '';
                                order = '';
                                family = '';
                                genus = '';
                              }),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 170, 80, 80)),
                              child: const Text('Clear',
                                  style: TextStyle(fontSize: 17)),
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
      String class_,
      String order,
      String family,
      String genus) async {
    final key = const Uuid().v4();
    final file = AWSFile.fromPath(image!.path);

    try {
      Amplify.Storage.uploadFile(
        key: key,
        localFile: file,
        options: const StorageUploadFileOptions(
          accessLevel: StorageAccessLevel.guest,
        ),
      );

      //send description and other post information to database
      httpHelpers
          .uploadPostRequest(
              title,
              description,
              sightingLocation,
              sightingTime,
              "https://ichthyolog175756-dev.s3.ap-southeast-1.amazonaws.com/public/$key",
              jwt,
              class_,
              order,
              family,
              genus)
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
    } catch (error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
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

  titleCallback(newValue) {
    final splitNames = newValue.split(', ');
    setState(() {
      title = splitNames[0];
    });
    final speciesRecord = singaporeRecords
        .singleWhere((record) => record.commonNames == newValue, orElse: () {
      return SpeciesRecord(
          class_: '',
          order: '',
          family: '',
          genus: '',
          species: '',
          commonNames: '');
    });
    if (speciesRecord.class_ != '' &&
        speciesRecord.order != '' &&
        speciesRecord.family != '' &&
        speciesRecord.genus != '') {
      setState(() {
        class_ = speciesRecord.class_;
        order = speciesRecord.order;
        family = speciesRecord.family;
        genus = speciesRecord.genus;
      });
    }
  }

  locationCallback(newValue) {
    setState(() {
      sightingLocation = newValue;
    });
  }

  Widget selectableTextForm(TextEditingController controller, String labelText,
      Icon leadingIcon, List<String> options, Function callback) {
    return Container(
        margin: const EdgeInsets.only(top: 12, left: 12, right: 12),
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 225, 235, 248),
            borderRadius: BorderRadius.circular(16)),
        child: TypeAheadFormField(
          hideOnLoading: true,
          hideOnEmpty: true,
          textFieldConfiguration: TextFieldConfiguration(
              controller: controller,
              decoration: InputDecoration(
                focusColor: const Color.fromARGB(255, 51, 64, 113),
                icon: leadingIcon,
                border: InputBorder.none,
                labelText: labelText,
              ),
              autofocus: true,
              style: const TextStyle(color: Color.fromARGB(255, 51, 64, 113))),
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          errorBuilder: (context, error) {
            return NoticeDialog(content: '$error');
          },
          suggestionsCallback: (pattern) {
            List<String> matches = [];
            if (pattern == '') {
              return matches;
            } else {
              matches.addAll(options);
              matches.retainWhere((matches) {
                return matches.toLowerCase().contains(pattern.toLowerCase());
              });
              return matches;
            }
          },
          onSuggestionSelected: (suggestion) {
            callback(suggestion);
            controller.text = suggestion;
          },
        ));
  }
}

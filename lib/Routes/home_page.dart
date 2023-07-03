import 'dart:io';
import 'package:flutter/material.dart';
import '../Helpers/standard_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:uuid/uuid.dart';
import '../Models/user.dart';
import '../Models/post.dart';
import '../Models/species.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'camera_page.dart';
import 'gallery_page.dart';
import 'post_page.dart';
import 'waiting_list_page.dart';
import 'statistics_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'stepper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  bool _authorised = false;
  File? image;
  String jwt = '';
  String newUsername = '';
  String newEmail = '';
  String newPassword = '';
  String oldPassword = '';
  String newTitle = '';
  String newDescription = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    helpers.checkJwt().then((token) {
      if (token == '') {
        setState(() {
          _authorised = false;
          jwt = '';
        });
      } else {
        setState(() {
          _authorised = true;
          jwt = token;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_authorised) {
      return const NoticeDialog(
          content: 'Not authorised. Please sign in again');
    } else {
      return FutureBuilder(
          future: httpHelpers.viewOwnUserProfileRequest(jwt),
          builder: ((context, snapshotUser) {
            if (snapshotUser.hasData) {
              return Scaffold(
                  appBar: AppBar(
                    leading: const Icon(Icons.menu),
                    title: const Text('Home Page'),
                    backgroundColor: const Color.fromARGB(255, 65, 90, 181),
                    actions: [
                      settingsButton(snapshotUser.data!),
                      logoutButton()
                    ],
                  ),
                  body: SingleChildScrollView(
                      physics: const ScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Color.fromARGB(255, 30, 51, 128),
                                Color.fromARGB(255, 66, 94, 185),
                              ],
                            )),
                            height:
                                MediaQuery.of(context).size.height * 1 / 2.5,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              18),
                                  profilePicture(snapshotUser.data!),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              36),
                                  Text(
                                    snapshotUser.data!.username,
                                    style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              80),
                                  Text(
                                    '${snapshotUser.data!.totalposts} sightings  |  ${snapshotUser.data!.speciescount} species',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ]),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 1 / 30),
                          userLevel(snapshotUser.data!),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 1 / 45),
                          FutureBuilder(
                              future: httpHelpers.viewOwnPostsRequest(jwt),
                              builder: ((context, snapshot) {
                                return snapshot.hasData
                                    ? galleryScreen(context, snapshot.data!,
                                        snapshotUser.data!)
                                    : snapshot.hasError &&
                                            snapshot.error == 'Posts not found'
                                        ? const Center(
                                            child: Text(
                                              'No sightings yet, start posting!',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 70, 88, 152),
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        : const LoadingScreen();
                              })),
                        ],
                      )),
                  bottomNavigationBar: snapshotUser.data!.expert
                      ? BottomAppBar(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Visit camera page to post sighting
                              cameraPageButton(snapshotUser.data!),
                              //Visit gallery page to view sightings
                              galleryPageButton(snapshotUser.data!),
                              //Visit statistics page to access sighting data
                              statsPageButton(),
                              //Visit waiting list page to verify/flag posts
                              waitingListPageButton(snapshotUser.data!)
                            ],
                          ),
                        )
                      : BottomAppBar(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Visit camera page to post sighting
                              cameraPageButton(snapshotUser.data!),
                              //Visit gallery page to view sightings
                              galleryPageButton(snapshotUser.data!),
                              //Visit statistics page to access sighting data
                              statsPageButton(),
                            ],
                          ),
                        ));
            } else if (snapshotUser.hasError) {
              return const NoticeDialog(
                  content: 'User not found! Please try again');
            } else {
              return Scaffold(
                  appBar: AppBar(
                    leading: const Icon(Icons.menu),
                    title: const Text('Home Page'),
                    backgroundColor: const Color.fromARGB(255, 65, 90, 181),
                  ),
                  body: const LoadingScreen());
            }
          }));
    }
  }

  Widget profilePicture(User user) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 75,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(user.profilepic),
        ),
        Positioned(
          bottom: 2,
          right: 4,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.white,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    60,
                  ),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(2, 4),
                    color: Colors.black.withOpacity(
                      0.3,
                    ),
                    blurRadius: 3,
                  ),
                ]),
            child: IconButton(
                padding: const EdgeInsets.all(2.0),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder: (context, setState) {
                          void uploadPic(
                            String jwt,
                          ) async {
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
                              httpHelpers
                                  .editUserProfilePicRequest(
                                      "https://ichthyolog175756-dev.s3.ap-southeast-1.amazonaws.com/public/$key",
                                      jwt)
                                  .then((String response) {
                                if (response == 'User Edited') {
                                  Navigator.pop(context);
                                  setState(() {
                                    image = null;
                                  });
                                  Fluttertoast.showToast(
                                    msg: 'Profile Picture Edited',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Profile Edit Failed :(',
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

                          Future<void> takePhoto(ImageSource source) async {
                            final imagePicker = ImagePicker();
                            final pickedImage =
                                await imagePicker.pickImage(source: source);

                            if (pickedImage != null) {
                              setState(() {
                                image = File(pickedImage.path);
                              });
                            }
                          }

                          Future<void> selectFromGallery() async {
                            takePhoto(ImageSource.gallery);
                          }

                          return AlertDialog(
                            title: const Text('Change Profile Picture'),
                            content: image != null
                                ? SingleChildScrollView(
                                    child: Center(
                                        child: Column(
                                    children: [
                                      Image.file(image!),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Wrap(
                                            spacing: 10,
                                            children: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  80,
                                                                  170,
                                                                  121)),
                                                  child: const Text("Confirm",
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  onPressed: () {
                                                    uploadPic(jwt);
                                                    image = null;
                                                  }),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  170,
                                                                  80,
                                                                  80)),
                                                  child: const Text("Cancel",
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      image = null;
                                                    });
                                                  })
                                            ],
                                          ))
                                    ],
                                  )))
                                : SingleChildScrollView(
                                    child: Center(
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.photo,
                                                size: 110,
                                                color: Color.fromARGB(
                                                    255, 51, 64, 113),
                                              ),
                                              const SizedBox(height: 10),
                                              ElevatedButton(
                                                onPressed: () => takePhoto(
                                                    ImageSource.camera),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 74, 112, 178),
                                                ),
                                                child: const Text('Take Photo'),
                                              ),
                                              ElevatedButton(
                                                onPressed: selectFromGallery,
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 87, 131, 206),
                                                ),
                                                child: const Text(
                                                    'Select from Gallery'),
                                              ),
                                            ])
                                      ]))),
                          );
                        });
                      }).then((value) {
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.add_a_photo),
                color: const Color.fromARGB(255, 70, 88, 152)),
          ),
        ),
      ],
    );
  }

  Widget userLevel(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          const Text(
            'Level ', // Replace with the actual level value
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 70, 88, 152)),
          ),
          const SizedBox(width: 5),
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color.fromARGB(255, 70, 88, 152),
            foregroundColor: Colors.white,
            child: Text(
              '${user.level}', // Replace with the actual level value
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
              child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: LinearProgressIndicator(
              value: user.level / 100,
              color: const Color.fromARGB(255, 76, 105, 210),
              backgroundColor: const Color.fromARGB(255, 158, 191, 255),
              minHeight: 20,
            ),
          )),
        ],
      ),
    );
  }

  Widget logoutButton() {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        helpers.logout(jwt, context);
      },
    );
  }

  Widget settingsButton(User user) {
    return IconButton(
      icon: const Icon(Icons.manage_accounts),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Edit Profile")),
                content: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          Container(
                              margin: const EdgeInsets.only(left: 5),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Edit Username',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )),
                          usernameField(),
                          Container(
                              margin: const EdgeInsets.only(top: 20, left: 5),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Edit Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )),
                          emailField(),
                          Container(
                              margin: const EdgeInsets.only(top: 20, left: 5),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Edit Password',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )),
                          newPasswordField(),
                        ]))),
                actions: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 80, 170, 121)),
                      child:
                          const Text("Confirm", style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        print(
                            'Username: $newUsername, Password: $newPassword, Email: $newEmail');

                        if (newUsername == '' &&
                            newEmail == '' &&
                            newPassword == '') {
                          Navigator.pop(context);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const NoticeDialog(
                                    content: 'No changes made!');
                              });
                        } else {
                          final bool? isValid =
                              _formKey.currentState?.validate();
                          if (isValid == true) {
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text('Double Confirm')),
                                    content: SingleChildScrollView(
                                        child: Column(children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, left: 5),
                                          alignment: Alignment.centerLeft,
                                          child: const Text(
                                            'Enter your current password',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 51, 64, 113)),
                                          )),
                                      oldPasswordField()
                                    ])),
                                    actions: [
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 80, 170, 121)),
                                          child: const Text("Confirm",
                                              style: TextStyle(fontSize: 12)),
                                          onPressed: () {
                                            httpHelpers
                                                .editUserProfileRequest(
                                                    newEmail,
                                                    newUsername,
                                                    oldPassword,
                                                    newPassword,
                                                    jwt)
                                                .then((response) {
                                              if (response == 'User Edited') {
                                                Navigator.pop(context);
                                                setState(() {
                                                  newUsername = '';
                                                  newEmail = '';
                                                  newPassword = '';
                                                });
                                                Fluttertoast.showToast(
                                                  msg: 'Profile Edited',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              } else if (response ==
                                                  'Incorrect Password') {
                                                Fluttertoast.showToast(
                                                  msg: 'Incorrect Password',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              } else if (response ==
                                                  'Email Already Exists') {
                                                Fluttertoast.showToast(
                                                  msg: 'Email Already In Use',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              } else if (response ==
                                                  'Username Already Exists') {
                                                Fluttertoast.showToast(
                                                  msg:
                                                      'Username Already In Use',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              } else {
                                                Fluttertoast.showToast(
                                                  msg: 'Profile Edit Failed :(',
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                );
                                              }
                                            });
                                          }),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 170, 80, 80)),
                                          child: const Text("Cancel",
                                              style: TextStyle(fontSize: 12)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            setState(() {
                                              newUsername = '';
                                              newEmail = '';
                                              newPassword = '';
                                            });
                                          })
                                    ],
                                  );
                                });
                          }
                        }
                      }),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 170, 80, 80)),
                      child:
                          const Text("Cancel", style: TextStyle(fontSize: 12)),
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          newUsername = '';
                          newEmail = '';
                          newPassword = '';
                        });
                      })
                ],
              );
            });
      },
    );
  }

  Widget cameraPageButton(User user) {
    return IconButton(
      icon: const Icon(Icons.add_a_photo_rounded,
          color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CameraPage(currUser: user)),
        );
      },
    );
  }

  Widget statsPageButton() {
    return IconButton(
      icon: const Icon(Icons.search, color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatisticsPage()),
        );
      },
    );
  }

  Widget galleryPageButton(User user) {
    return IconButton(
      icon: const Icon(Icons.photo_library,
          color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GalleryPage(currUser: user)),
        );
      },
    );
  }

  Widget waitingListPageButton(User user) {
    return IconButton(
      icon: const Icon(
        Icons.feedback,
        color: Color.fromARGB(255, 52, 66, 117),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WaitingListPage(
                    isExpert: user.expert,
                  )),
        );
      },
    );
  }

  Widget newPasswordField() {
    return Container(
        margin: const EdgeInsets.only(top: 8, left: 5, right: 5, bottom: 15),
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 225, 235, 248),
            borderRadius: BorderRadius.circular(16)),
        child: TextFormField(
          obscureText: true,
          onChanged: (value) {
            setState(() {
              newPassword = value;
            });
          },
          validator: (value) {
            if (value!.isNotEmpty) {
              if (value.length < 6 || value.length > 20) {
                return 'Password must be 6-20 characters';
              } else if (!isValidPassword(value)) {
                return 'Password must contain at least one capital letter and one special character';
              }
            }
            return null;
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Leave blank if not changing',
          ),
        ));
  }

  Widget oldPasswordField() {
    return Container(
        margin: const EdgeInsets.only(top: 14, left: 5, right: 5),
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 225, 235, 248),
            borderRadius: BorderRadius.circular(16)),
        child: TextFormField(
          obscureText: true,
          onChanged: (value) {
            setState(() {
              oldPassword = value;
            });
          },
          validator: (value) {
            if (value!.length < 6 || value.length > 20) {
              return 'Password must be 6-20 characters';
            } else if (!isValidPassword(value)) {
              return 'Password must contain at least one capital letter and one special character';
            }
            return null;
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Current password',
          ),
        ));
  }

  Widget emailField() {
    return Container(
        margin: const EdgeInsets.only(top: 8, left: 5, right: 5),
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 225, 235, 248),
            borderRadius: BorderRadius.circular(16)),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isNotEmpty && !isValidEmail(value)) {
              return 'Please enter a valid email';
            } else {
              return null;
            }
          },
          onChanged: (value) {
            setState(() {
              newEmail = value;
            });
          },
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Leave blank if not changing",
          ),
        ));
  }

  Widget usernameField() {
    return Container(
      margin: const EdgeInsets.only(top: 8, left: 5, right: 5),
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 225, 235, 248),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
        validator: (value) {
          if (value!.isNotEmpty && value.trim().length > 25) {
            return 'Username must be less than 25 characters';
          } else {
            return null;
          }
        },
        onChanged: (value) {
          setState(() {
            newUsername = value;
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Leave blank if not changing',
        ),
      ),
    );
  }

  bool isValidUsername(String username) {
    if (username.isEmpty || username.length > 25) {
      return false;
    }
    return true;
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^[\w-]+(.[\w-]+)@[a-zA-Z0-9-]+(.[a-zA-Z0-9-]+)(.[a-zA-Z]{2,})$')
        .hasMatch(email);
  }

  bool isValidPassword(String password) {
    // Check if the password meets the criteria
    bool hasCapitalLetter = false;
    bool hasSpecialCharacter = false;

    for (int i = 0; i < password.length; i++) {
      var char = password[i];
      if (char == char.toUpperCase()) {
        hasCapitalLetter = true;
      }
      if (char.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        hasSpecialCharacter = true;
      }
    }

    return hasCapitalLetter && hasSpecialCharacter;
  }

  Widget editPostButton(Post post) {
    return IconButton(
      constraints: const BoxConstraints(),
      icon: CircleAvatar(
          radius: 13,
          backgroundColor: Colors.white.withOpacity(0.85),
          child: const Icon(
            Icons.edit,
            size: 15,
            color: Color.fromARGB(255, 39, 49, 133),
          )),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              String newTitle = '';
              String newClass = '';
              String newOrder = '';
              String newFamily = '';
              String newGenus = '';
              String newSpecies = '';
              String newLocation = '';
              final TextEditingController titleController =
                  TextEditingController();
              final TextEditingController locationController =
                  TextEditingController();
              List<String> allSpecies = <String>[];
              for (var record in singaporeRecords) {
                allSpecies.add(record.commonNames);
              }
              return StatefulBuilder(builder: (context, setState) {
                classCallback(newValue) {
                  setState(() {
                    newClass = newValue;
                  });
                }

                orderCallback(newValue) {
                  setState(() {
                    newOrder = newValue;
                  });
                }

                familyCallback(newValue) {
                  setState(() {
                    newFamily = newValue;
                  });
                }

                genusCallback(newValue) {
                  setState(() {
                    newGenus = newValue;
                  });
                }

                titleCallback(newValue) {
                  final splitNames = newValue.split(', ');
                  setState(() {
                    newTitle = splitNames[0];
                  });
                  final speciesRecord = singaporeRecords.singleWhere(
                      (record) => record.commonNames == newValue, orElse: () {
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
                      newClass = speciesRecord.class_;
                      newOrder = speciesRecord.order;
                      newFamily = speciesRecord.family;
                      newGenus = speciesRecord.genus;
                      newSpecies = speciesRecord.species;
                    });
                  }
                }

                locationCallback(newValue) {
                  setState(() {
                    newLocation = newValue;
                  });
                }

                return AlertDialog(
                  title: const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text("Edit Post"),
                  ),
                  content: SingleChildScrollView(
                      child: Column(children: [
                    Container(
                        margin: const EdgeInsets.only(left: 5),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Edit Species Name',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        )),
                    selectableTextForm(
                        titleController, post.title, allSpecies, titleCallback),
                    Container(
                        margin: const EdgeInsets.only(top: 10, left: 5),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Edit Description',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        )),
                    Container(
                        margin:
                            const EdgeInsets.only(top: 8, left: 5, right: 5),
                        padding: const EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 225, 235, 248),
                            borderRadius: BorderRadius.circular(16)),
                        child: TextFormField(
                          initialValue: post.description,
                          minLines: 1,
                          maxLines: 8,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Edit Description'),
                          onChanged: (value) {
                            setState(() {
                              newDescription = value;
                            });
                          },
                        )),
                    Container(
                        margin: const EdgeInsets.only(left: 5, top: 10),
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Edit Location',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113)),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: selectableTextForm(
                            locationController,
                            post.sightingLocation,
                            locations,
                            locationCallback)),
                    Wrap(
                      children: [
                        const Text(
                          'Class: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113),
                              fontSize: 13),
                        ),
                        Text(
                          newClass == '' ? '${post.class_}   ' : '$newClass   ',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const Text(
                          'Order: ',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 51, 64, 113),
                              fontSize: 13),
                        ),
                        Text(
                          newOrder == '' ? '${post.order}' : newOrder,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Wrap(
                          children: [
                            const Text(
                              'Family: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 51, 64, 113),
                                  fontSize: 13),
                            ),
                            Text(
                              newFamily == ''
                                  ? '${post.family}   '
                                  : '$newFamily   ',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const Text(
                              'Genus: ',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 51, 64, 113),
                                  fontSize: 13),
                            ),
                            Text(
                              newGenus == '' ? '${post.genus}' : newGenus,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )),
                  ])),
                  actions: [
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 7),
                        child: Wrap(spacing: 5, children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(content: StatefulBuilder(
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
                                padding: const EdgeInsets.all(8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                backgroundColor:
                                    const Color.fromARGB(255, 102, 154, 217)),
                            child: const Text(
                              'Edit Classification',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor:
                                      const Color.fromARGB(255, 80, 170, 121)),
                              child: const Text(
                                "Confirm",
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                httpHelpers
                                    .editPostInfoRequest(
                                        post.postid,
                                        jwt,
                                        newTitle,
                                        newDescription,
                                        newLocation,
                                        newClass,
                                        newOrder,
                                        newFamily,
                                        newGenus,
                                        newSpecies)
                                    .then((response) {
                                  if (response == 'Post Edited') {
                                    Navigator.pop(context);
                                    setState(() {
                                      newClass = '';
                                      newOrder = '';
                                      newFamily = '';
                                      newGenus = '';
                                    });
                                    Fluttertoast.showToast(
                                      msg: 'Post Edited',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                    );
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'Post Edit Failed :(',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                    );
                                  }
                                });
                              }),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(8),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  backgroundColor:
                                      const Color.fromARGB(255, 170, 80, 80)),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(fontSize: 12),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                setState(() {
                                  newClass = '';
                                  newOrder = '';
                                  newFamily = '';
                                  newGenus = '';
                                });
                              })
                        ])),
                  ],
                );
              });
            }).then((value) {
          setState(() {});
        });
      },
    );
  }

  Widget deletePostButton(Post post) {
    return IconButton(
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
      icon: CircleAvatar(
          radius: 13,
          backgroundColor: Colors.white.withOpacity(0.85),
          child: const Icon(
            Icons.delete,
            size: 15,
            color: Color.fromARGB(255, 155, 47, 47),
          )),
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: const Text("Warning"),
                  content:
                      const Text('Are you sure? This action is irreversible!'),
                  actions: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 80, 170, 121)),
                        child: const Text("Yes"),
                        onPressed: () {
                          httpHelpers.deletePostRequest(post.postid, jwt).then(
                            (response) {
                              Navigator.pop(context);
                              if (response == 'Post Deleted') {
                                setState(() {});
                                Fluttertoast.showToast(
                                  msg: 'Post deleted',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                              } else {
                                Fluttertoast.showToast(
                                  msg: 'Post failed to delete :(',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                );
                              }
                            },
                          );
                        }),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 170, 80, 80)),
                        child: const Text("Cancel"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ]);
            });
      },
    );
  }

  Widget clickableImage(Post post, User user) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Stack(children: [
              InkWell(
                  child: Ink.image(
                      image: NetworkImage(post.pic), fit: BoxFit.cover),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PostPage(
                                postid: post.postid,
                                isExpert: user.expert,
                              )),
                    );
                  }),
              Positioned(
                  right: 8,
                  child: Row(
                      children: [editPostButton(post), deletePostButton(post)]))
            ])));
  }

  Widget galleryScreen(BuildContext context, List<Post> posts, User user) {
    return Column(children: [
      GridView.builder(
          itemCount: posts.length,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 7.0,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return postCard(posts[index], user);
          },
          shrinkWrap: true,
          padding: const EdgeInsets.all(12.0))
    ]);
  }

  Widget postCard(Post post, User user) {
    return Card(
        color: const Color.fromARGB(255, 253, 254, 255),
        elevation: 4.5,
        shadowColor: const Color.fromARGB(255, 113, 165, 255),
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ListTile(
                  dense: true,
                  minVerticalPadding: 0,
                  horizontalTitleGap: 0,
                  visualDensity:
                      const VisualDensity(vertical: -4, horizontal: 0),
                  contentPadding: post.species == null
                      ? const EdgeInsets.symmetric(horizontal: 10)
                      : const EdgeInsets.only(
                          left: 10, right: 10, top: 2, bottom: 2),
                  title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: post.species == null
                          ? [
                              Text(
                                post.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color.fromARGB(255, 33, 53, 88)),
                              ),
                            ]
                          : [
                              Text(
                                post.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                    color: Color.fromARGB(255, 33, 53, 88)),
                              ),
                              Text(
                                post.species!,
                                style: const TextStyle(
                                    fontSize: 8,
                                    color: Color.fromARGB(255, 33, 53, 88)),
                              ),
                            ]),
                  trailing: CircleAvatar(
                    radius: 8,
                    backgroundColor: post.flagged
                        ? const Color.fromARGB(255, 152, 72, 85)
                        : const Color.fromARGB(255, 175, 103, 51),
                    child: Icon(
                      post.flagged ? Icons.priority_high : Icons.pending,
                      size: 10,
                      color: Colors.white,
                    ),
                  )),
              //Post Image
              clickableImage(post, user),
              Padding(
                  padding: const EdgeInsets.only(
                      left: 12, top: 8, right: 9, bottom: 8),
                  child: Row(children: [
                    const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.pin_drop,
                          size: 14,
                          color: Color.fromARGB(255, 51, 64, 113),
                        )),
                    Expanded(
                      child: Text(post.sightingLocation,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 33, 53, 88))),
                    ),
                  ])),
            ]));
  }

  Widget selectableTextForm(TextEditingController controller, String hintText,
      List<String> options, Function callback) {
    return Container(
        margin: const EdgeInsets.only(top: 8, left: 5, right: 5),
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
                hintText: hintText,
                focusColor: const Color.fromARGB(255, 51, 64, 113),
                border: InputBorder.none,
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

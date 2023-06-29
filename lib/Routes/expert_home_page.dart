import 'dart:io';
import 'package:flutter/material.dart';
import '../Helpers/standard_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:uuid/uuid.dart';
import '../Models/user.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'camera_page.dart';
import 'gallery_page.dart';
import 'statistics_page.dart';
import 'waiting_list_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExpertHomePage extends StatefulWidget {
  const ExpertHomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<ExpertHomePage> {
  bool _authorised = false;
  String jwt = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();
  String newUsername = '';
  String newEmail = '';
  String newPassword = '';
  String oldPassword = '';
  final _formKey = GlobalKey<FormState>();
  File? image;

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
      return SingleChildScrollView(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<User>(
                future: httpHelpers.viewOwnUserProfileRequest(jwt),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Scaffold(
                      appBar: AppBar(
                        leading: const Icon(Icons.menu),
                        title: const Text('Expert Home'),
                        backgroundColor: const Color.fromARGB(255, 65, 90, 181),
                        actions: [
                          settingsButton(snapshot.data!),
                          logoutButton()
                        ],
                      ),
                      body: Column(
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
                                  profilePicture(snapshot.data!),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              1 /
                                              36),
                                  Text(
                                    snapshot.data!.username,
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
                                    '${snapshot.data!.totalposts} sightings  |  ${snapshot.data!.speciescount} species',
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ]),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 1 / 30),
                          userLevel(snapshot.data!),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 1 / 30),
                          Expanded(
                              child: Container(
                            color: const Color.fromARGB(255, 197, 215, 255),
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: [
                              Container(
                                  padding: EdgeInsets.only(
                                      left: 20,
                                      top: MediaQuery.of(context).size.height *
                                          1 /
                                          36),
                                  alignment: Alignment.centerLeft,
                                  child: const Text(
                                    'Statistics',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )),
                              const SizedBox(height: 10),
                              const Text(
                                'Species with Most Posts: ', // Replace with the actual species
                                style: TextStyle(fontSize: 16),
                              ),
                            ]),
                          )),
                        ],
                      ),
                      bottomNavigationBar: BottomAppBar(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Visit camera page to post sighting
                            cameraPageButton(),

                            //Visit gallery page to view sightings
                            galleryPageButton(),

                            //Visit statistics page to access sighting data
                            statsPageButton(),

                            //Visit waiting list page to verify sightings
                            waitingListPageButton()
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const NoticeDialog(
                        content: 'User not found! Please try again');
                  } else {
                    return const LoadingScreen();
                  }
                }))),
      );
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
                          void _uploadPic(
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
                                                    _uploadPic(jwt);
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
                title: const Text("Edit Profile"),
                content: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          Container(
                              margin: const EdgeInsets.only(left: 15),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Edit Username',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )),
                          usernameField(),
                          Container(
                              margin: const EdgeInsets.only(top: 20, left: 15),
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Edit Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 51, 64, 113)),
                              )),
                          emailField(),
                          Container(
                              margin: const EdgeInsets.only(top: 20, left: 15),
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
                                    title: const Text('Double Confirm'),
                                    content: SingleChildScrollView(
                                        child: Column(children: [
                                      Container(
                                          margin: const EdgeInsets.only(
                                              top: 20, left: 15),
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

  Widget cameraPageButton() {
    return IconButton(
      icon: const Icon(Icons.add_a_photo_rounded),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CameraPage()),
        );
      },
    );
  }

  Widget statsPageButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatisticsPage()),
        );
      },
    );
  }

  Widget galleryPageButton() {
    return IconButton(
      icon: const Icon(Icons.photo_library),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GalleryPage()),
        );
      },
    );
  }

  Widget waitingListPageButton() {
    return IconButton(
      icon: const Icon(Icons.feedback),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WaitingListPage()),
        );
      },
    );
  }

  Widget newPasswordField() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
            hintText: 'Leave blank if not changing',
          ),
        ));
  }

  Widget oldPasswordField() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
            hintText: 'Enter a password',
          ),
        ));
  }

  Widget emailField() {
    return Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value!.isNotEmpty) {
              if (!isValidEmail(value)) {
                return 'Please enter a valid email';
              }
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
            hintText: "Leave blank if not changing",
          ),
        ));
  }

  Widget usernameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: TextFormField(
        validator: (value) {
          if (value!.isNotEmpty) {
            if (value.trim().length > 25) {
              return 'Username must be less than 25 characters';
            }
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
}

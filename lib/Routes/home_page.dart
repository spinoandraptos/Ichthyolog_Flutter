import 'dart:io';
import 'package:flutter/material.dart';
import '../Helpers/standard_widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:uuid/uuid.dart';
import '../Models/user.dart';
import '../Models/post.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'camera_page.dart';
import 'gallery_page.dart';
import 'post_page.dart';
import 'waiting_list_page.dart';
import 'statistics_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'stepper.dart';

class RegularHomePage extends StatefulWidget {
  const RegularHomePage({super.key});
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<RegularHomePage> {
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
      return FutureBuilder<User>(
          future: httpHelpers.viewOwnUserProfileRequest(jwt),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                  appBar: AppBar(
                    leading: const Icon(Icons.menu),
                    title: const Text('Home Page'),
                    backgroundColor: const Color.fromARGB(255, 65, 90, 181),
                    actions: [settingsButton(snapshot.data!), logoutButton()],
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
                          FutureBuilder(
                              future: httpHelpers.viewOwnPostsRequest(jwt),
                              builder: ((context, snapshot) {
                                return snapshot.hasData
                                    ? galleryScreen(context, snapshot.data!)
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
                  bottomNavigationBar: snapshot.data!.expert
                      ? BottomAppBar(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Visit camera page to post sighting
                              cameraPageButton(),
                              //Visit gallery page to view sightings
                              galleryPageButton(),
                              //Visit statistics page to access sighting data
                              statsPageButton(),
                              //Visit waiting list page to verify/flag posts
                              waitingListPageButton()
                            ],
                          ),
                        )
                      : BottomAppBar(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Visit camera page to post sighting
                              cameraPageButton(),
                              //Visit gallery page to view sightings
                              galleryPageButton(),
                              //Visit statistics page to access sighting data
                              statsPageButton(),
                            ],
                          ),
                        ));
            } else if (snapshot.hasError) {
              return const NoticeDialog(
                  content: 'User not found! Please try again');
            } else {
              return const LoadingScreen();
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
      icon: const Icon(Icons.add_a_photo_rounded,
          color: Color.fromARGB(255, 52, 66, 117)),
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
      icon: const Icon(Icons.search, color: Color.fromARGB(255, 52, 66, 117)),
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
      icon: const Icon(Icons.photo_library,
          color: Color.fromARGB(255, 52, 66, 117)),
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
      icon: const Icon(
        Icons.feedback,
        color: Color.fromARGB(255, 52, 66, 117),
      ),
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
            hintText: "Leave blank if not changing",
          ),
        ));
  }

  Widget usernameField() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(3),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String newClass = '';
                String newOrder = '';
                String newFamily = '';
                String newGenus = '';

                return StatefulBuilder(builder: (context, setState) {
                  classCallback(newValue) {
                    setState(() {
                      newClass = newValue;
                    });
                    print(newClass);
                  }

                  orderCallback(newValue) {
                    setState(() {
                      newOrder = newValue;
                    });
                    print(newOrder);
                  }

                  familyCallback(newValue) {
                    setState(() {
                      newFamily = newValue;
                    });
                    print(newFamily);
                  }

                  genusCallback(newValue) {
                    setState(() {
                      newGenus = newValue;
                    });
                    print(newGenus);
                  }

                  return AlertDialog(
                    title: const Text("Edit Post"),
                    content: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                          margin: const EdgeInsets.only(left: 15),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Edit Title',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 51, 64, 113)),
                          )),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 15, right: 15),
                        child: TextFormField(
                          initialValue: post.title,
                          decoration: const InputDecoration(
                            hintText: 'Edit Title',
                          ),
                          onChanged: (value) {
                            setState(() {
                              newTitle = value;
                            });
                          },
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20, left: 15),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'Edit Description',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 51, 64, 113)),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, bottom: 15),
                          child: TextFormField(
                            initialValue: post.description,
                            minLines: 1,
                            maxLines: 8,
                            decoration: const InputDecoration(
                                hintText: 'Edit Description'),
                            onChanged: (value) {
                              setState(() {
                                newDescription = value;
                              });
                            },
                          )),
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
                            newClass == ''
                                ? '${post.class_}   '
                                : '$newClass   ',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Text(
                            'Order: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 51, 64, 113),
                                fontSize: 14),
                          ),
                          Text(
                            newOrder == '' ? '${post.order}' : newOrder,
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
                            newFamily == ''
                                ? '${post.family}   '
                                : '$newFamily   ',
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
                            newGenus == '' ? '${post.genus}' : newGenus,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ])),
                    actions: [
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
                            backgroundColor:
                                const Color.fromARGB(255, 102, 154, 217)),
                        child: const Text(
                          'Edit Classification',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 80, 170, 121)),
                          child: const Text("Confirm",
                              style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            httpHelpers
                                .editPostInfoRequest(
                                    post.postid,
                                    jwt,
                                    newTitle,
                                    newDescription,
                                    newClass,
                                    newOrder,
                                    newFamily,
                                    newGenus)
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
                              backgroundColor:
                                  const Color.fromARGB(255, 170, 80, 80)),
                          child: const Text("Cancel",
                              style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              newClass = '';
                              newOrder = '';
                              newFamily = '';
                              newGenus = '';
                            });
                          })
                    ],
                  );
                });
              });
        },
        child: const Text('Edit Post',
            style: TextStyle(
                fontSize: 10, color: Color.fromARGB(255, 33, 53, 88))));
  }

  Widget deletePostButton(Post post) {
    return TextButton(
        style: TextButton.styleFrom(
            padding: const EdgeInsets.all(3),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text("Warning"),
                    content: const Text(
                        'Are you sure? This action is irreversible!'),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 80, 170, 121)),
                          child: const Text("Yes"),
                          onPressed: () {
                            httpHelpers
                                .deletePostRequest(post.postid, jwt)
                                .then(
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
        child: const Text('Delete Post',
            style: TextStyle(
                fontSize: 10, color: Color.fromARGB(255, 33, 53, 88))));
  }

  Widget clickableImage(Post post) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
            child: Ink.image(image: NetworkImage(post.pic), fit: BoxFit.cover),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostPage(postid: post.postid)),
              );
            }),
      ),
    );
  }

  Widget galleryScreen(BuildContext context, List<Post> posts) {
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
            return ownPostCard(posts[index]);
          },
          shrinkWrap: true,
          padding: const EdgeInsets.all(12.0))
    ]);
  }

  Widget ownPostCard(Post post) {
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
              Padding(
                  padding: const EdgeInsets.only(left: 9, top: 5, right: 9),
                  child: Row(children: [
                    Container(
                        padding: const EdgeInsets.only(right: 4),
                        width: MediaQuery.of(context).size.width * 1 / 2.85,
                        child: Text(
                          post.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Color.fromARGB(255, 33, 53, 88)),
                        )),
                    CircleAvatar(
                      radius: 9,
                      backgroundColor: post.verified
                          ? const Color.fromARGB(255, 73, 155, 109)
                          : post.flagged
                              ? const Color.fromARGB(255, 152, 72, 85)
                              : const Color.fromARGB(255, 175, 103, 51),
                      child: Icon(
                        post.verified
                            ? Icons.verified
                            : post.flagged
                                ? Icons.priority_high
                                : Icons.pending,
                        size: 10,
                        color: Colors.white,
                      ),
                    )
                  ])),

              //Post Image
              clickableImage(post),

              //Clickable Buttons
              Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 4, bottom: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      editPostButton(post),
                      deletePostButton(post),
                    ],
                  )),
              Container(
                  padding: const EdgeInsets.only(left: 6, bottom: 5, right: 8),
                  child: Text('Sighted at ${post.sightingLocation}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontSize: 9,
                          color: Color.fromARGB(255, 33, 53, 88)))),
            ]));
  }
}

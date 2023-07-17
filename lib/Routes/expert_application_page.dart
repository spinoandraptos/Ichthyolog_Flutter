import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Helpers/standard_widgets.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import '../Models/user.dart';
import '../Models/expert_application_request.dart';
import 'camera_page.dart';
import 'home_page.dart';
import 'gallery_page.dart';
import 'statistics_page.dart';
import 'waiting_list_page.dart';

class ExpertApplicationPage extends StatefulWidget {
  final User currUser;

  const ExpertApplicationPage({
    Key? key,
    required this.currUser,
  }) : super(key: key);
  @override
  ExpertApplicationPageState createState() => ExpertApplicationPageState();
}

class ExpertApplicationPageState extends State<ExpertApplicationPage> {
  String jwt = '';
  final helpers = Helpers();
  final httpHelpers = HttpHelpers();
  final _formKey = GlobalKey<FormState>();

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

  refreshCallback() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: widget.currUser.expert
              ? const Text('Expert Application Reviews')
              : const Text('Expert Applications'),
          backgroundColor: const Color.fromARGB(255, 65, 90, 181),
          actions: [logoutButton()]),
      body: Column(children: [
        widget.currUser.expert
            ? const SizedBox.shrink()
            : Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.only(top: 20, bottom: 20, right: 15),
                  child: submitApplicationButton(widget.currUser),
                )),
        FutureBuilder(
            future: widget.currUser.expert
                ? httpHelpers.viewAllExpertApplicationsRequest(jwt)
                : httpHelpers.viewOwnExpertApplicationsRequest(
                    widget.currUser.userid, jwt),
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                    padding: const EdgeInsets.only(top: 6),
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 8 / 10,
                    ),
                    child: SingleChildScrollView(
                        child: Column(children: [
                      const SizedBox(
                        height: 8,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return snapshot.data![index].approved == 'false'
                                ? Column(
                                    children: [
                                      ExpertApplication(
                                        request: snapshot.data![index],
                                        currUser: widget.currUser,
                                        jwt: jwt,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 18, top: 6, bottom: 8),
                                          child: Text(
                                              snapshot
                                                  .data![index].rejectionReason,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 51, 64, 113),
                                                  fontSize: 12)))
                                    ],
                                  )
                                : ExpertApplication(
                                    request: snapshot.data![index],
                                    currUser: widget.currUser,
                                    jwt: jwt,
                                  );
                          })
                    ])));
              } else if (snapshot.hasError &&
                  snapshot.error == 'Applications not found') {
                return const Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(
                        'No applications currently!',
                        style: TextStyle(
                            color: Color.fromARGB(255, 70, 88, 152),
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                      )
                    ]));
              } else {
                print(snapshot.error);
                return const LoadingScreen();
              }
            }))
      ]),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.currUser.expert
              ? [
                  homePageButton(refreshCallback),
                  cameraPageButton(refreshCallback),
                  galleryPageButton(widget.currUser, refreshCallback),
                  statsPageButton(refreshCallback),
                  waitingListPageButton(refreshCallback)
                ]
              : [
                  homePageButton(refreshCallback),
                  cameraPageButton(refreshCallback),
                  galleryPageButton(widget.currUser, refreshCallback),
                  statsPageButton(refreshCallback),
                ],
        ),
      ),
    );
  }

  Widget submitApplicationButton(User currUser) {
    return ElevatedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController nameController = TextEditingController();
              TextEditingController ageController = TextEditingController();
              TextEditingController genderController = TextEditingController();
              TextEditingController occupationController =
                  TextEditingController();
              TextEditingController emailController = TextEditingController();
              TextEditingController contactController = TextEditingController();
              TextEditingController credentialsController =
                  TextEditingController();
              return AlertDialog(
                title: const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Text('Enter Your Particulars')),
                content: SingleChildScrollView(
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          infoTextField(nameController, 'Enter full name', 3,
                              Icons.person, noValidation, TextInputType.name),
                          infoTextField(
                              ageController,
                              'Enter age',
                              1,
                              Icons.person,
                              ageValidation,
                              TextInputType.number),
                          infoTextField(
                              genderController,
                              'Enter gender',
                              1,
                              Icons.person,
                              genderValidation,
                              TextInputType.text),
                          infoTextField(
                              occupationController,
                              'Enter occupation',
                              1,
                              Icons.work,
                              noValidation,
                              TextInputType.text),
                          infoTextField(
                            emailController,
                            'Enter email',
                            2,
                            Icons.mail,
                            emailValidation,
                            TextInputType.emailAddress,
                          ),
                          infoTextField(
                              contactController,
                              'Enter contact number',
                              1,
                              Icons.call,
                              contactValidation,
                              TextInputType.phone),
                          infoTextField(
                              credentialsController,
                              'Enter credentials',
                              10,
                              Icons.badge,
                              noValidation,
                              TextInputType.text),
                        ]))),
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                          onPressed: () {
                            final bool? isValid =
                                _formKey.currentState?.validate();
                            if (isValid == true) {
                              httpHelpers
                                  .addExpertApplicationRequest(
                                      currUser.userid,
                                      nameController.text,
                                      int.parse(ageController.text),
                                      genderController.text,
                                      occupationController.text,
                                      emailController.text,
                                      int.parse(contactController.text),
                                      credentialsController.text,
                                      jwt)
                                  .then(
                                (response) {
                                  Fluttertoast.showToast(
                                    msg: response,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                  if (response ==
                                      'Application added successfully!') {
                                    setState(() {});
                                    Navigator.pop(context);
                                  }
                                },
                              );
                            } else {
                              print('HEY');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                                  const Color.fromARGB(255, 80, 170, 121)),
                          child: const Text("Submit"))),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10, right: 5),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor:
                                  const Color.fromARGB(255, 170, 80, 80)),
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          }))
                ],
              );
            });
      },
      style: ElevatedButton.styleFrom(
          padding:
              const EdgeInsets.only(left: 10, top: 6, bottom: 6, right: 10),
          minimumSize: Size.zero,
          backgroundColor: const Color.fromARGB(255, 93, 123, 200),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: const Text('Submit Application', style: TextStyle(fontSize: 14)),
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

  Widget homePageButton(Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.home, color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        ).then((value) => refreshCallback());
      },
    );
  }

  Widget cameraPageButton(Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.add_a_photo_rounded,
          color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CameraPage(
                    currUser: widget.currUser,
                  )),
        ).then((value) => refreshCallback());
      },
    );
  }

  Widget galleryPageButton(User user, Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.photo_library,
          color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GalleryPage(currUser: user)),
        ).then((value) => refreshCallback());
      },
    );
  }

  Widget statsPageButton(Function refreshCallback) {
    return IconButton(
      icon: const Icon(Icons.search, color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatisticsPage()),
        ).then((value) => refreshCallback());
      },
    );
  }

  Widget waitingListPageButton(Function refreshCallback) {
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
                    currUser: widget.currUser,
                  )),
        ).then((value) => refreshCallback());
      },
    );
  }

  Widget infoTextField(
      TextEditingController controller,
      String labelText,
      int maxLines,
      IconData icon,
      Function validate,
      TextInputType? keyboardtype) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 235, 242, 252),
            borderRadius: BorderRadius.circular(16)),
        child: TextFormField(
          minLines: 1,
          maxLines: maxLines,
          controller: controller,
          validator: (value) {
            return validate(value);
          },
          keyboardType: keyboardtype,
          decoration: InputDecoration(
            icon: Icon(icon, color: const Color.fromARGB(255, 51, 64, 113)),
            border: InputBorder.none,
            labelText: labelText,
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
        ));
  }

  noValidation(String? value) {
    if (value == '' || value!.trim().isEmpty) {
      return 'Field cannot be empty';
    } else {
      return null;
    }
  }

  ageValidation(String? value) {
    if (value == '' || value!.trim().isEmpty) {
      return 'Field cannot be empty';
    } else if (double.tryParse(value) == null || value.contains('.')) {
      return 'Please enter an integer age';
    } else if (int.parse(value) < 10 || int.parse(value) > 122) {
      return 'Please enter a valid age';
    } else {
      return null;
    }
  }

  genderValidation(String? value) {
    if (value != null &&
        value != '' &&
        value.toLowerCase() != 'male' &&
        value.toLowerCase() != 'female' &&
        value.toLowerCase() != 'transgender' &&
        value.toLowerCase() != 'transgender male' &&
        value.toLowerCase() != 'transgender female' &&
        value.toLowerCase() != 'transgender-male' &&
        value.toLowerCase() != 'transgender-female' &&
        value.toLowerCase() != 'transman' &&
        value.toLowerCase() != 'transwoman' &&
        value.toLowerCase() != 'nonbinary' &&
        value.toLowerCase() != 'non binary' &&
        value.toLowerCase() != 'non-binary' &&
        value.toLowerCase() != 'queer' &&
        value.toLowerCase() != 'genderqueer' &&
        value.toLowerCase() != 'agender' &&
        value.toLowerCase() != 'gender fluid' &&
        value.toLowerCase() != 'gender-fluid') {
      return 'Please enter a valid gender';
    } else {
      return null;
    }
  }

  contactValidation(String? value) {
    if (value == '' || value!.trim().isEmpty) {
      return 'Field cannot be empty';
    } else if (double.tryParse(value) == null || value.contains('.')) {
      return 'Please enter a contact number';
    } else if (value.length != 8) {
      return 'Please enter a valid contact number';
    } else {
      return null;
    }
  }

  emailValidation(String? value) {
    if (value == '' || value!.trim().isEmpty) {
      return 'Field cannot be empty';
    } else if (!RegExp(
            r'^[\w-]+(.[\w-]+)@[a-zA-Z0-9-]+(.[a-zA-Z0-9-]+)(.[a-zA-Z]{2,})$')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    } else {
      return null;
    }
  }
}

class ExpertApplication extends StatefulWidget {
  final ExpertApplicationRequest request;
  final User currUser;
  final String jwt;

  const ExpertApplication({
    Key? key,
    required this.request,
    required this.currUser,
    required this.jwt,
  }) : super(key: key);
  @override
  ExpertApplicationState createState() => ExpertApplicationState();
}

class ExpertApplicationState extends State<ExpertApplication> {
  bool expanded = false;
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(
            left: 5,
            right: 5,
            bottom: widget.request.approved == 'false' ? 10 : 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 12,
            backgroundColor: widget.request.approved == 'not processed'
                ? const Color.fromARGB(255, 175, 103, 51)
                : widget.request.approved == 'true'
                    ? const Color.fromARGB(255, 73, 155, 109)
                    : const Color.fromARGB(255, 152, 72, 85),
            child: Icon(
              widget.request.approved == 'not processed'
                  ? Icons.pending
                  : widget.request.approved == 'true'
                      ? Icons.done
                      : Icons.close,
              size: 14,
              color: Colors.white,
            ),
          ),
          horizontalTitleGap: 10,
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
          title: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Applicant: ${widget.request.authorName}',
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 51, 64, 113))),
                  const Text('Credentials:',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 51, 64, 113))),
                  Text(widget.request.credentials,
                      style: TextStyle(
                        fontSize: 12,
                      )),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        expanded = !expanded;
                      });
                    },
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(2),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text(
                      expanded ? 'Minimise' : 'View application details',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 51, 64, 113),
                          fontSize: 12),
                    ),
                  ),
                  expanded
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Age: ${widget.request.age}',
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                            Text('Gender: ${widget.request.gender}',
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                            Text('Occupation: ${widget.request.occupation}',
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                            Text('Email: ${widget.request.email}',
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                            Text('Contact: ${widget.request.contact}',
                                style: const TextStyle(
                                  fontSize: 12,
                                )),
                          ],
                        )
                      : const SizedBox.shrink()
                ],
              )),
          trailing: widget.request.approved == 'not processed'
              ? widget.currUser.expert
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text('Double Confirmation')),
                                      content: Text(
                                          'Approve ${widget.request.authorName}’s expert application?'),
                                      actions: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, bottom: 7),
                                            child: Wrap(
                                              spacing: 5,
                                              children: [
                                                ElevatedButton(
                                                    onPressed: () {
                                                      httpHelpers
                                                          .approveExpertApplicationRequest(
                                                              widget.currUser
                                                                  .userid,
                                                              widget.request
                                                                  .applicationId,
                                                              widget.jwt)
                                                          .then(
                                                        (response) {
                                                          Fluttertoast
                                                              .showToast(
                                                            msg: response,
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .BOTTOM,
                                                            timeInSecForIosWeb:
                                                                1,
                                                          );
                                                          if (response ==
                                                              'Application approved successfully!') {
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        },
                                                      );
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        minimumSize: Size.zero,
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                80,
                                                                170,
                                                                121)),
                                                    child:
                                                        const Text("Approve")),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        minimumSize: Size.zero,
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                170,
                                                                80,
                                                                80)),
                                                    child: const Text("Cancel"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    })
                                              ],
                                            ))
                                      ]);
                                });
                          },
                          child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.done,
                                size: 20,
                                color: Color.fromARGB(255, 73, 155, 109),
                              ))),
                      InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController
                                      rejectionReasonController =
                                      TextEditingController();
                                  return AlertDialog(
                                      title: const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child:
                                              Text('Submit Rejection Reason')),
                                      content: Container(
                                          margin: const EdgeInsets.only(
                                              top: 8, left: 5, right: 5),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 225, 235, 248),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: TextField(
                                            controller:
                                                rejectionReasonController,
                                            minLines: 1,
                                            maxLines: 8,
                                            decoration: InputDecoration(
                                              focusColor: const Color.fromARGB(
                                                  255, 51, 64, 113),
                                              hintText:
                                                  'Reason for application rejection',
                                              border: InputBorder.none,
                                              suffixIcon: IconButton(
                                                onPressed: () {
                                                  rejectionReasonController
                                                      .clear();
                                                },
                                                icon: const Icon(Icons.clear),
                                              ),
                                            ),
                                          )),
                                      actions: [
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10, bottom: 7),
                                            child: Wrap(spacing: 5, children: [
                                              ElevatedButton(
                                                  onPressed: () {
                                                    httpHelpers
                                                        .rejectExpertApplicationRequest(
                                                            widget.request
                                                                .applicationId,
                                                            rejectionReasonController
                                                                .text,
                                                            widget.jwt)
                                                        .then(
                                                      (response) {
                                                        Fluttertoast.showToast(
                                                          msg: response,
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                        );
                                                        if (response ==
                                                            'Application rejected successfully!') {
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },
                                                    );
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      minimumSize: Size.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              80,
                                                              170,
                                                              121)),
                                                  child: const Text("Submit")),
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      minimumSize: Size.zero,
                                                      tapTargetSize:
                                                          MaterialTapTargetSize
                                                              .shrinkWrap,
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              80,
                                                              80)),
                                                  child: const Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  })
                                            ]))
                                      ]);
                                });
                          },
                          child: const Padding(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.close,
                                size: 20,
                                color: Color.fromARGB(255, 152, 72, 85),
                              )))
                    ])
                  : InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: const Padding(
                                      padding: EdgeInsets.only(left: 5),
                                      child: Text('Double Confirmation')),
                                  content: const Text(
                                      'Delete your expert application?'),
                                  actions: [
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 7),
                                        child: Wrap(
                                          spacing: 5,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  httpHelpers
                                                      .deleteExpertApplicationRequest(
                                                          widget.request
                                                              .applicationId,
                                                          widget.jwt)
                                                      .then(
                                                    (response) {
                                                      Fluttertoast.showToast(
                                                        msg: response,
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.BOTTOM,
                                                        timeInSecForIosWeb: 1,
                                                      );
                                                      if (response ==
                                                          'Application deleted successfully!') {
                                                        setState(() {});
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 80, 170, 121)),
                                                child: const Text("Confirm")),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    minimumSize: Size.zero,
                                                    tapTargetSize:
                                                        MaterialTapTargetSize
                                                            .shrinkWrap,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 170, 80, 80)),
                                                child: const Text("Cancel"),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                })
                                          ],
                                        ))
                                  ]);
                            });
                      },
                      child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.delete,
                            size: 20,
                            color: Color.fromARGB(255, 170, 80, 80),
                          )))
              : const SizedBox.shrink(),
        ));
  }
}

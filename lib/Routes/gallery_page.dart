import 'package:flutter/material.dart';
import '../Helpers/standard_widgets.dart';
import '../Models/post.dart';
import '../Models/user.dart';
import 'post_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Helpers/helper.dart';
import '../Helpers/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'stepper.dart';
import 'home_page.dart';
import 'camera_page.dart';
import 'statistics_page.dart';
import 'waiting_list_page.dart';
import '../Models/species.dart';

class GalleryPage extends StatefulWidget {
  final User currUser;
  const GalleryPage({super.key, required this.currUser});
  @override
  GalleryPageState createState() => GalleryPageState();
}

class GalleryPageState extends State<GalleryPage> {
  String jwt = '';
  Map<String, dynamic> decodedJWT = {};
  final httpHelpers = HttpHelpers();
  final helpers = Helpers();

  String newDescription = '';

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
          decodedJWT = JwtDecoder.decode(token);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: httpHelpers.viewAllPostsRequest(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: jwt == ''
                  ? AppBar(
                      title: const Text('Sighting Gallery'),
                      backgroundColor: const Color.fromARGB(255, 65, 90, 181),
                    )
                  : AppBar(
                      title: const Text('Sighting Gallery'),
                      backgroundColor: const Color.fromARGB(255, 65, 90, 181),
                      actions: [logoutButton()],
                    ),
              body: galleryScreen(context, snapshot.data!),
              bottomNavigationBar: BottomAppBar(
                child: jwt == ''
                    ? null
                    : widget.currUser.expert
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Visit home page to view profile
                              homePageButton(),
                              //Visit camera page to post sighting
                              cameraPageButton(),
                              //Visit statistics page to access sighting data
                              statsPageButton(),
                              //Visit waiting list page to verify/flag posts
                              waitingListPageButton()
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Visit home page to view profile
                              homePageButton(),
                              //Visit camera page to post sighting
                              cameraPageButton(),
                              //Visit statistics page to access sighting data
                              statsPageButton(),
                            ],
                          ),
              ),
            );
          } else if (snapshot.hasError) {
            return const NoticeDialog(
                content: 'Posts not found! Please try again');
          } else {
            return const LoadingScreen();
          }
        }));
  }

  Widget logoutButton() {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        helpers.logout(jwt, context);
      },
    );
  }

  Widget homePageButton() {
    return IconButton(
      icon: const Icon(Icons.home, color: Color.fromARGB(255, 52, 66, 117)),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
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
          MaterialPageRoute(
              builder: (context) => CameraPage(
                    currUser: widget.currUser,
                  )),
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

  Widget waitingListPageButton() {
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
                    isExpert: widget.currUser.expert,
                  )),
        );
      },
    );
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
                              style: TextStyle(fontSize: 11),
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
                                style: TextStyle(fontSize: 11),
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
                                  Fluttertoast.showToast(
                                    msg: response,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                  );
                                  if (response == 'Post Edited') {
                                    Navigator.pop(context);
                                    setState(() {
                                      newClass = '';
                                      newOrder = '';
                                      newFamily = '';
                                      newGenus = '';
                                    });
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
                                style: TextStyle(fontSize: 11),
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

  Widget clickableImage(Post post) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: decodedJWT['username'] == post.authorname
                ? Stack(children: [
                    InkWell(
                        child: Ink.image(
                            image: NetworkImage(post.pic), fit: BoxFit.cover),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostPage(
                                      postid: post.postid,
                                      isExpert: widget.currUser.expert,
                                    )),
                          );
                        }),
                    Positioned(
                        right: 8,
                        child: Row(children: [
                          editPostButton(post),
                          deletePostButton(post)
                        ]))
                  ])
                : InkWell(
                    child: Ink.image(
                        image: NetworkImage(post.pic), fit: BoxFit.cover),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PostPage(
                                  postid: post.postid,
                                  isExpert: widget.currUser.expert,
                                )),
                      );
                    })));
  }

  Widget galleryLegend() {
    return const Padding(
        padding: EdgeInsets.only(left: 18, top: 10, right: 9),
        child: Row(children: [
          Text(
            "Key:",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color.fromARGB(255, 60, 89, 139)),
          ),
          SizedBox(width: 8),
          CircleAvatar(
              radius: 7,
              backgroundColor: Color.fromARGB(255, 73, 155, 109),
              child: Icon(
                Icons.verified,
                size: 10,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Text(
            "[ ID Verified ]",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color.fromARGB(255, 73, 155, 109)),
          ),
          SizedBox(width: 14),
          CircleAvatar(
              radius: 7,
              backgroundColor: Color.fromARGB(255, 175, 103, 51),
              child: Icon(
                Icons.pending,
                size: 10,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Text(
            "[ Pending Verification ]",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color.fromARGB(255, 175, 103, 51)),
          ),
          SizedBox(width: 14),
          CircleAvatar(
              radius: 7,
              backgroundColor: Color.fromARGB(255, 152, 72, 85),
              child: Icon(
                Icons.priority_high,
                size: 10,
                color: Colors.white,
              )),
          SizedBox(width: 4),
          Text(
            "[ Flagged ]",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
                color: Color.fromARGB(255, 152, 72, 85)),
          ),
        ]));
  }

  Widget galleryScreen(BuildContext context, List<Post> posts) {
    return SingleChildScrollView(
        child: SizedBox(
            child: Column(children: [
      galleryLegend(),
      GridView.builder(
          itemCount: posts.length,
          physics: const ScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 7.0,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return postCard(posts[index]);
          },
          shrinkWrap: true,
          padding: const EdgeInsets.all(12.0))
    ])));
  }

  Widget postCard(Post post) {
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
              clickableImage(post),
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

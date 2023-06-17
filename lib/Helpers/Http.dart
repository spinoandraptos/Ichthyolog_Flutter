import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ichthyolog/Models/comment.dart';
import 'package:ichthyolog/Models/post.dart';
import 'package:ichthyolog/Models/user.dart';

//class which stores the functions responsible for backend communication
class HttpHelpers {
  //signup request returns success message or error message
  //the string can be used for pop-up display etc.
  Future<String> signupRequest(
      String username, String password, String email) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/user';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'username': username,
        'password': password,
        'email': email
      }),
    );
    if (response.statusCode == 201) {
      return ('Signup Successful');
    } else {
      return 'Signup failed with status: ${response.statusCode}.';
    }
  }

  Future<String> loginRequest(
      String email, String username, String password) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/user/login';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(<String, String>{
        'email': email,
        'username': username,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      return ('Password Incorrect');
    } else {
      print(response.headers);
      print(response.statusCode);
      return ('Username Not Found');
    }
  }

  Future<String> logoutRequest(String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/user/logout';
    var response = await http.post(Uri.parse(url), headers: <String, String>{
      'Content-type': 'application/json; charset=UTF-8',
      'Authorisation': jwt
    });
    if (response.statusCode == 200) {
      return ('Logged out');
    } else {
      return ('Logout failed}');
    }
  }

  Future<User> viewOwnUserProfileRequest(String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/user';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)[0]);
    } else {
      return Future.error("User Not Found");
    }
  }

  Future<User> viewAnyUserProfileRequest(int userid) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/user/$userid';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body)[0]);
    } else {
      return Future.error("User Not Found");
    }
  }

  Future<String> updateUserRequest(
      String email, String username, String password, String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/user';
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
      body: json.encode(<String, String>{
        'email': email,
        'username': username,
        'password': password
      }),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      return ('Password Incorrect');
    } else {
      return ('Username Not Found');
    }
  }

  Future<List<Post>> viewAllPostsRequest() async {
    String url = 'https://ichthyolog-nodejs.onrender.com/posts';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List<Post> postlist = [];
      var responseData = json.decode(response.body);
      for (var everypost in responseData) {
        Post post = Post.fromJson(everypost);
        postlist.add(post);
      }
      return postlist;
    } else {
      return Future.error("Posts Not Found");
    }
  }

  Future<List<Post>> viewAllVerifiedPostsRequest() async {
    String url = 'https://ichthyolog-nodejs.onrender.com/posts/verified';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List<Post> postlist = [];
      var responseData = json.decode(response.body);
      for (var everypost in responseData) {
        Post post = Post.fromJson(everypost);
        postlist.add(post);
      }
      return postlist;
    } else {
      return Future.error("Posts Not Found");
    }
  }

  Future<List<Post>> viewAllUnverifiedPostsRequest() async {
    String url = 'https://ichthyolog-nodejs.onrender.com/posts/unverified';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List<Post> postlist = [];
      var responseData = json.decode(response.body);
      for (var everypost in responseData) {
        Post post = Post.fromJson(everypost);
        postlist.add(post);
      }
      return postlist;
    } else {
      return Future.error("Posts Not Found");
    }
  }

  Future<Post> viewPostRequest(int postid) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/post/$postid';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Post.fromJson(json.decode(response.body)[0]);
    } else {
      return Future.error("Post Not Found");
    }
  }

  Future<String> uploadPostRequest(
      String title,
      String description,
      String sightingLocation,
      String sightingTime,
      String imageURL,
      String jwt,
      String class_,
      String order,
      String family,
      String genus) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/post';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
      body: json.encode(<String, dynamic>{
        'title': title,
        'description': description,
        'sightingLocation': sightingLocation,
        'sightingTime': sightingTime,
        'imageURL': imageURL,
        '_class': class_,
        'order': order,
        'family': family,
        'genus': genus
      }),
    );

    if (response.statusCode == 201) {
      return ('Post Uploaded');
    } else {
      return ('Post Upload Failed');
    }
  }

  Future<List<Comment>> viewPostCommentsRequest(int postid) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/comments/$postid';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      List<Comment> comments = [];
      var responseData = json.decode(response.body);
      for (var everycomment in responseData) {
        Comment comment = Comment.fromJson(everycomment);
        comments.add(comment);
      }
      return comments;
    } else {
      return Future.error("Comments Not Found");
    }
  }

  Future<Comment> viewLatestPostCommentRequest(int postid) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/comment/$postid';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(json.decode(response.body)[0]);
    } else {
      return Future.error("Comment Not Found");
    }
  }

  Future<List<Comment>> viewUserCommentsRequest(String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/comments/user';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      List<Comment> comments = [];
      var responseData = json.decode(response.body);
      for (var everycomment in responseData) {
        Comment comment = Comment.fromJson(everycomment);
        comments.add(comment);
      }
      return comments;
    } else {
      return Future.error("Comments Not Found");
    }
  }

  Future<Comment> viewCommentRequest(int commentid) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/comments/$commentid';
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return Comment.fromJson(json.decode(response.body)[0]);
    } else {
      return Future.error("Comment Not Found");
    }
  }

  Future<String> addCommentRequest(
      int postid, String content, String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/comment';
    var response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
      body:
          json.encode(<String, dynamic>{'postid': postid, 'content': content}),
    );
    if (response.statusCode == 201) {
      return ('Comment Posted');
    } else {
      return ('Comment Post Failed');
    }
  }

  Future<String> deleteUserRequest(String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/user';
    var response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('User Deleted');
    } else {
      return ('User Deletion Failed');
    }
  }

  Future<String> deletePostRequest(int postid, String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/post/$postid';
    var response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('Post Deleted');
    } else {
      return ('Post Deletion Failed');
    }
  }

  Future<String> deleteCommentRequest(int commentid, String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/comment/$commentid';
    var response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('Comment Deleted');
    } else {
      return ('Comment Deletion Failed');
    }
  }

  Future<String> verifyPostRequest(int postid, String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/post/$postid/verify';
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('Post Verified');
    } else {
      return ('Post Verification Failed');
    }
  }

  Future<String> flagPostRequest(int postid, String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/post/$postid/flag';
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('Post Flagged');
    } else {
      return ('Post Flagging Failed');
    }
  }

  Future<String> unFlagPostRequest(int postid, String jwt) async {
    String url = 'https://ichthyolog-nodejs.onrender.com/post/$postid/unflag';
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('Post Unflagged');
    } else {
      return ('Post Unflagging Failed');
    }
  }

  Future<String> upVoteCommentRequest(int commentid, String jwt) async {
    String url =
        'https://ichthyolog-nodejs.onrender.com/post/$commentid/upvote';
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('Comment Upvoted');
    } else {
      return ('Comment Upvoting Failed');
    }
  }

  Future<String> downVoteCommentRequest(int commentid, String jwt) async {
    String url =
        'https://ichthyolog-nodejs.onrender.com/post/$commentid/downvote';
    var response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
    );
    if (response.statusCode == 200) {
      return ('Comment Downvoted');
    } else {
      return ('Comment Downvoting Failed');
    }
  }
}

// statistics request
Future<List<String>> searchSpecies(String species, String startTime,
    String endTime, String sightinglocation) async {
  var uri = Uri.https(
      'ichthyolog-nodejs.onrender.com', '/statistics/species/$species', {
    'species': species,
    'startTime': startTime,
    'endTime': endTime,
    'sightingLocation': sightinglocation,
  });

  var response = await http.get(uri, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });

  if (response.statusCode == 200) {
    List<String> dataList = [];
    var responseData = json.decode(response.body);
    dataList.add(responseData['count'].toString());
    dataList.add(responseData['latest_sightingtime'].toString());
    dataList.add(responseData['latest_sightinglocation'].toString());
    return dataList;
  } else {
    throw Exception('Species not found! Error ${response.statusCode}');
  }
}

Future<List<String>> searchClassification(
    String class_,
    String order,
    String family,
    String genus,
    String startTime,
    String endTime,
    String sightinglocation) async {
  if (class_ != '' && order == '' && family == '' && genus == '') {
    return searchClass(class_, startTime, endTime, sightinglocation);
  } else if (class_ != '' && order != '' && family == '' && genus == '') {
    return searchOrder(class_, order, startTime, endTime, sightinglocation);
  } else if (class_ != '' && order != '' && family != '' && genus == '') {
    return searchFamily(
        class_, order, family, startTime, endTime, sightinglocation);
  } else if (class_ != '' && order != '' && family != '' && genus != '') {
    return searchGenus(
        class_, order, family, genus, startTime, endTime, sightinglocation);
  } else {
    throw Exception('Classification not found!');
  }
}

Future<List<String>> searchClass(String class_, String startTime,
    String endTime, String sightinglocation) async {
  String url = 'https://ichthyolog-nodejs.onrender.com/statistics/$class_';
  var response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    List<String> speciesList = [];
    var responseData = json.decode(response.body);
    for (var everyspecies in responseData) {
      speciesList.add(everyspecies['title']);
    }
    return speciesList;
  } else {
    throw Exception('Class not found! Error ${response.statusCode}');
  }
}

Future<List<String>> searchOrder(String class_, String order, String startTime,
    String endTime, String sightinglocation) async {
  String url =
      'https://ichthyolog-nodejs.onrender.com/statistics/$class_/$order';
  var response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    List<String> speciesList = [];
    var responseData = json.decode(response.body);
    for (var everyspecies in responseData) {
      speciesList.add(everyspecies['title']);
    }
    return speciesList;
  } else {
    throw Exception('Order not found! Error ${response.statusCode}');
  }
}

Future<List<String>> searchFamily(String class_, String order, String family,
    String startTime, String endTime, String sightinglocation) async {
  String url =
      'https://ichthyolog-nodejs.onrender.com/statistics/$class_/$order/$family';
  var response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    List<String> speciesList = [];
    var responseData = json.decode(response.body);
    for (var everyspecies in responseData) {
      speciesList.add(everyspecies['title']);
    }
    return speciesList;
  } else {
    throw Exception('Family not found! Error ${response.statusCode}');
  }
}

Future<List<String>> searchGenus(
    String class_,
    String order,
    String family,
    String genus,
    String startTime,
    String endTime,
    String sightinglocation) async {
  String url =
      'https://ichthyolog-nodejs.onrender.com/statistics/$class_/$order/$family/$genus';
  var response = await http.get(
    Uri.parse(url),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    List<String> speciesList = [];
    var responseData = json.decode(response.body);
    for (var everyspecies in responseData) {
      speciesList.add(everyspecies['title']);
    }
    return speciesList;
  } else {
    throw Exception('Genus not found! Error ${response.statusCode}');
  }
}

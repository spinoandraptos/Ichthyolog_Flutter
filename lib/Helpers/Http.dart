import 'dart:convert';
import 'package:flutter/material.dart';
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

  Future<User> viewUserRequest(String jwt) async {
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
      throw Exception('User not found! Error ${response.statusCode}');
    }
  }

  Future<User> viewAnyUserRequest(int userid) async {
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
      throw Exception('User not found! Error ${response.statusCode}');
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
      throw Exception('Posts not found! Error ${response.statusCode}');
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
      throw Exception('Posts not found! Error ${response.statusCode}');
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
      throw Exception('Posts not found! Error ${response.statusCode}');
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
      throw Exception('Post not found! Error ${response.statusCode}');
    }
  }

  Future<String> uploadPostRequest(
      String title,
      String description,
      String sightingLocation,
      String sightingTime,
      String imageURL,
      String jwt,
      int level,
      int postNumber) async {
    String url1 = 'https://ichthyolog-nodejs.onrender.com/post';
    var response1 = await http.post(
      Uri.parse(url1),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
      body: json.encode(<String, dynamic>{
        'title': title,
        'description': description,
        'sightingLocation': sightingLocation,
        'sightingTime': sightingTime,
        'imageURL': imageURL
      }),
    );
    String url2 = 'https://ichthyolog-nodejs.onrender.com/user/level';
    var response2 = await http.put(
      Uri.parse(url2),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
      body: json.encode(<String, dynamic>{'level': level}),
    );
    String url3 = 'https://ichthyolog-nodejs.onrender.com/user/post';
    var response3 = await http.put(
      Uri.parse(url3),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorisation': jwt
      },
      body: json.encode(<String, dynamic>{'post_number': postNumber}),
    );
    if (response1.statusCode == 201 &&
        response2.statusCode == 200 &&
        response3.statusCode == 200) {
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
      throw Exception('Comment not found! Error ${response.statusCode}');
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
      throw Exception('Comment not found! Error ${response.statusCode}');
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
      throw Exception('Comment not found! Error ${response.statusCode}');
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
      throw Exception('Comment not found! Error ${response.statusCode}');
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
      print(response.body);
      return ('Comment Deletion Failed');
    }
  }
}

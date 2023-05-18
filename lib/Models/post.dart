//This file stores classes that represent the major objects used
//These classes will be used to store the data returned from backend

//User class for user posts
class Post {
  final int postid;
  final String title;
  final String content;
  final String pic;
  final String comments;

//use of required keyword as none of these fields can be null
  Post({
    required this.postid,
    required this.title,
    required this.content,
    required this.pic,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        postid: json['postid'],
        title: json['title'],
        content: json['content'],
        pic: json['pic'],
        comments: json['comments']);
  }
}

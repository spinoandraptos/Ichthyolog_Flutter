//This file stores classes that represent the major objects used
//These classes will be used to store the data returned from backend

//Post class for user posts
class Post {
  final int postid;
  final int userid;
  final String authorname;
  final String title;
  final String description;
  final String pic;
  final String uploadTime;
  final String sightingTime;
  final String sightingLocation;

//use of required keyword as none of these fields can be null
  Post({
    required this.postid,
    required this.userid,
    required this.authorname,
    required this.title,
    required this.description,
    required this.pic,
    required this.uploadTime,
    required this.sightingTime,
    required this.sightingLocation,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        postid: json['postid'],
        userid: json['userid'],
        authorname: json['authorname'],
        title: json['title'],
        description: json['description'],
        pic: json['imageurl'],
        uploadTime: json['time'],
        sightingLocation: json['sightinglocation'],
        sightingTime: json['sightingtime']);
  }
}

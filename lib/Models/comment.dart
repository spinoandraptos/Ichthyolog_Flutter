import 'package:intl/intl.dart';

class Comment {
  final int commentId;
  final int authorId;
  final int postId;
  final String authorName;
  final String content;
  final String authorPic;
  final String postedTime;
  final int upvotes;

  Comment(
      {required this.commentId,
      required this.authorId,
      required this.postId,
      required this.authorName,
      required this.authorPic,
      required this.content,
      required this.postedTime,
      required this.upvotes});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        commentId: json['commentid'],
        authorId: json['authorid'],
        postId: json['postid'],
        authorName: json['authorname'],
        content: json['content'],
        authorPic: json['authorpic'],
        postedTime: DateFormat("hh:mm a, dd/MM/yyyy")
            .format(DateTime.parse(json['postedtime'])),
        upvotes: json['upvotes']);
  }
}

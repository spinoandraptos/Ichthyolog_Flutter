class Comment {
  final int commentId;
  final int authorId;
  final int postId;
  final String authorName;
  final String content;
  final String authorPic;
  final String postedTime;

  Comment(
      {required this.commentId,
      required this.authorId,
      required this.postId,
      required this.authorName,
      required this.authorPic,
      required this.content,
      required this.postedTime});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        commentId: json['commentid'],
        authorId: json['authorid'],
        postId: json['postid'],
        authorName: json['authorname'],
        content: json['content'],
        authorPic: json['authorpic'],
        postedTime: json['postedtime']);
  }
}

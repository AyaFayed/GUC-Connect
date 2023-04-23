class Post {
  String id;
  String content;
  String? file;
  String authorId;
  String authorName;
  List<Reply> replies;
  DateTime createdAt;

  Post(
      {required this.id,
      required this.content,
      required this.file,
      required this.authorId,
      required this.authorName,
      required this.replies,
      required this.createdAt});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'file': file,
        'authorId': authorId,
        'authorName': authorName,
        'replies': replies.map((reply) => reply.toJson()).toList(),
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        content: json['content'],
        file: json['file'],
        authorId: json['authorId'],
        authorName: json['authorName'],
        replies: (json['replies'] as List<dynamic>)
            .map((reply) => Reply.fromJson(reply))
            .toList(),
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );
}

class Reply {
  String content;
  String authorId;
  String authorName;
  DateTime createdAt;

  Reply({
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'authorId': authorId,
        'authorName': authorName,
        'createdAt': createdAt.millisecondsSinceEpoch,
      };

  static Reply fromJson(Map<String, dynamic> json) => Reply(
        content: json['content'],
        authorId: json['authorId'],
        authorName: json['authorName'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      );
}

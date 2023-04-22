class Post {
  String id;
  String content;
  String? file;
  String author;
  List<Reply> replies;

  Post(
      {required this.id,
      required this.content,
      required this.file,
      required this.author,
      required this.replies});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'file': file,
        'author': author,
        'replies': replies.map((reply) => reply.toJson()).toList(),
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
      id: json['id'],
      content: json['content'],
      file: json['file'],
      author: json['author'],
      replies: (json['replies'] as List<dynamic>)
          .map((reply) => Reply.fromJson(reply))
          .toList());
}

class Reply {
  String content;
  String author;

  Reply({
    required this.content,
    required this.author,
  });

  Map<String, dynamic> toJson() => {
        'content': content,
        'author': author,
      };

  static Reply fromJson(Map<String, dynamic> json) => Reply(
        content: json['content'],
        author: json['author'],
      );
}

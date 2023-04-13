class Event {
  String id;
  String creator;
  String course;
  String title;
  String description;
  List<String> files;

  Event(
      {required this.id,
      required this.creator,
      required this.course,
      required this.title,
      required this.description,
      required this.files});

  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'course': course,
        'title': title,
        'description': description,
        'files': files
      };

  static Event fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        creator: json['creator'],
        course: json['course'],
        title: json['title'],
        description: json['description'],
        files: (json['files'] as List<dynamic>).cast<String>(),
      );
}

class DisplayEvent {
  String title;
  String subtitle;
  String description;
  List<String> files;

  DisplayEvent(
      {required this.title,
      required this.subtitle,
      required this.description,
      required this.files});
}

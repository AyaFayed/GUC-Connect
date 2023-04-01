class Event {
  String id;
  String creator;
  String course;
  String title;
  String notes;
  List<String> files;

  Event(
      {required this.id,
      required this.creator,
      required this.course,
      required this.title,
      required this.notes,
      required this.files});

  Map<String, dynamic> toJson() => {
        'id': id,
        'creator': creator,
        'course': course,
        'title': title,
        'notes': notes,
        'files': files
      };

  static Event fromJson(Map<String, dynamic> json) => Event(
        id: json['id'],
        creator: json['creator'],
        course: json['course'],
        title: json['title'],
        notes: json['notes'],
        files: (json['files'] as List<dynamic>).cast<String>(),
      );
}

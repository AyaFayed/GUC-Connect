class Course {
  String id;
  String name;
  List<String> professorIds;
  List<String> taIds;
  List<String> groupIds;
  List<String> tutorialIds;
  List<String> postIds;

  Course({
    required this.id,
    required this.name,
    required this.professorIds,
    required this.taIds,
    required this.groupIds,
    required this.tutorialIds,
    required this.postIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'professorIds': professorIds,
        'taIds': taIds,
        'groupIds': groupIds,
        'tutorialIds': tutorialIds,
        'postIds': postIds,
      };

  static Course fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        name: json['name'],
        professorIds: (json['professorIds'] as List<dynamic>).cast<String>(),
        taIds: (json['taIds'] as List<dynamic>).cast<String>(),
        groupIds: (json['groupIds'] as List<dynamic>).cast<String>(),
        tutorialIds: (json['tutorialIds'] as List<dynamic>).cast<String>(),
        postIds: (json['postIds'] as List<dynamic>).cast<String>(),
      );
}

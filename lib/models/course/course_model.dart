class Course {
  String id;
  String name;
  List<String> professorIds;
  List<String> taIds;

  Course({
    required this.id,
    required this.name,
    required this.professorIds,
    required this.taIds,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'professorIds': professorIds,
        'taIds': taIds,
      };

  static Course fromJson(Map<String, dynamic> json) => Course(
        id: json['id'],
        name: json['name'],
        professorIds: (json['professorIds'] as List<dynamic>).cast<String>(),
        taIds: (json['taIds'] as List<dynamic>).cast<String>(),
      );
}

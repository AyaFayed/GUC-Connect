import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class UserModel {
  String? id;
  String name;
  UserType type;
  UserModel({required this.id, required this.name, required this.type});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'type': type.name};

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        type: getUserTypeFromString(json['type']),
      );
}

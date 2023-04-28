import 'package:guc_scheduling_app/shared/constants.dart';
import 'package:guc_scheduling_app/shared/helper.dart';

class UserModel {
  String? id;
  String? token;
  String name;
  UserType type;
  UserModel(
      {required this.id,
      required this.token,
      required this.name,
      required this.type});

  Map<String, dynamic> toJson() =>
      {'id': id, 'token': token, 'name': name, 'type': type.name};

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        token: json['token'],
        name: json['name'],
        type: getUserTypeFromString(json['type']),
      );
}

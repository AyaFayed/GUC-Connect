class Reminder {
  String id;
  String deviceToken;
  String eventId;

  Reminder(
      {required this.id, required this.deviceToken, required this.eventId});

  Map<String, dynamic> toJson() =>
      {'id': id, 'deviceToken': deviceToken, 'eventId': eventId};

  static Reminder fromJson(Map<String, dynamic> json) => Reminder(
      id: json['id'],
      deviceToken: json['deviceToken'],
      eventId: json['eventId']);
}

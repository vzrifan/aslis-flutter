// To parse this JSON data, do
//
//     final eventModel = eventModelFromJson(jsonString);

import 'dart:convert';

EventModel eventModelFromJson(String str) =>
    EventModel.fromJson(json.decode(str));

String eventModelToJson(EventModel data) => json.encode(data.toJson());

class EventModel {
  EventModel({
    required this.id,
    required this.eventName,
  });

  String id;
  String eventName;

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json["id"] ?? "",
        eventName: json["event_name"] ?? "",
      );

  static List<EventModel> fromJsonList(List list) {
    if (list.length == 0) return List<EventModel>.empty();
    return list.map((item) => EventModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_name": eventName,
      };
}

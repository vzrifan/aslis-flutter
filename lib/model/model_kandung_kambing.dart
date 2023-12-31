// To parse this JSON data, do
//
//     final parentKambingModel = parentKambingModelFromJson(jsonString);

import 'dart:convert';

ParentKambingModel parentKambingModelFromJson(String str) =>
    ParentKambingModel.fromJson(json.decode(str));

String parentKambingModelToJson(ParentKambingModel data) =>
    json.encode(data.toJson());

class ParentKambingModel {
  ParentKambingModel({
    required this.id,
    required this.cattleName,
    required this.cattleId,
  });

  String id;
  String cattleName;
  String cattleId;

  factory ParentKambingModel.fromJson(Map<String, dynamic> json) =>
      ParentKambingModel(
        id: json["id"],
        cattleName: json["cattle_name"] ?? "",
        cattleId: json["cattle_id"] ?? "",
      );

  static List<ParentKambingModel> fromJsonList(List list) {
    if (list.length == 0) return List<ParentKambingModel>.empty();
    return list.map((item) => ParentKambingModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "cattle_name": cattleName,
        "cattle_id": cattleId,
      };
}

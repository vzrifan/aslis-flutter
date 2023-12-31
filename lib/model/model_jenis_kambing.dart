// To parse this JSON data, do
//
//     final jenisKambingModel = jenisKambingModelFromJson(jsonString);

import 'dart:convert';

JenisKambingModel jenisKambingModelFromJson(String str) =>
    JenisKambingModel.fromJson(json.decode(str));

String jenisKambingModelToJson(JenisKambingModel data) =>
    json.encode(data.toJson());

class JenisKambingModel {
  JenisKambingModel({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory JenisKambingModel.fromJson(Map<String, dynamic> json) =>
      JenisKambingModel(
        id: json["id"],
        name: json["name"],
      );

  static List<JenisKambingModel> fromJsonList(List list) {
    if (list.length == 0) return List<JenisKambingModel>.empty();
    return list.map((item) => JenisKambingModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

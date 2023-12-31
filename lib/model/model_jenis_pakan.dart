// To parse this JSON data, do
//
//     final jenisPakanModel = jenisPakanModelFromJson(jsonString);

import 'dart:convert';

JenisPakanModel jenisPakanModelFromJson(String str) =>
    JenisPakanModel.fromJson(json.decode(str));

String jenisPakanModelToJson(JenisPakanModel data) =>
    json.encode(data.toJson());

class JenisPakanModel {
  JenisPakanModel({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory JenisPakanModel.fromJson(Map<String, dynamic> json) =>
      JenisPakanModel(
        id: json["id"].toString(),
        name: json["name"],
      );

  static List<JenisPakanModel> fromJsonList(List list) {
    if (list.length == 0) return List<JenisPakanModel>.empty();
    return list.map((item) => JenisPakanModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

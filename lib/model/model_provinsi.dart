// To parse this JSON data, do
//
//     final ProvinceModel = ProvinceModelFromJson(jsonString);

import 'dart:convert';

ProvinceModel ProvinceModelFromJson(String str) =>
    ProvinceModel.fromJson(json.decode(str));

String ProvinceModelToJson(ProvinceModel data) => json.encode(data.toJson());

class ProvinceModel {
  ProvinceModel({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory ProvinceModel.fromJson(Map<String, dynamic> json) => ProvinceModel(
        id: json["id"],
        name: json["name"],
      );

  static List<ProvinceModel> fromJsonList(List list) {
    if (list.length == 0) return List<ProvinceModel>.empty();
    return list.map((item) => ProvinceModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

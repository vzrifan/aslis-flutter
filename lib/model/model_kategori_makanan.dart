// To parse this JSON data, do
//
//     final kategoriMakananModel = kategoriMakananModelFromJson(jsonString);

import 'dart:convert';

KategoriMakananModel kategoriMakananModelFromJson(String str) =>
    KategoriMakananModel.fromJson(json.decode(str));

String kategoriMakananModelToJson(KategoriMakananModel data) =>
    json.encode(data.toJson());

class KategoriMakananModel {
  KategoriMakananModel({
    required this.id,
    required this.foodId,
    required this.foodName,
  });

  String id;
  String foodId;
  String foodName;

  factory KategoriMakananModel.fromJson(Map<String, dynamic> json) =>
      KategoriMakananModel(
        id: json["id"] ?? "",
        foodId: json["food_id"] ?? "",
        foodName: json["food_name"] ?? "",
      );

  static List<KategoriMakananModel> fromJsonList(List list) {
    if (list.length == 0) return List<KategoriMakananModel>.empty();
    return list.map((item) => KategoriMakananModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "food_id": foodId,
        "food_name": foodName,
      };
}

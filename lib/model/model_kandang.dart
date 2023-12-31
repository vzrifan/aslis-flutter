// To parse this JSON data, do
//
//     final kandangModel = kandangModelFromJson(jsonString);

import 'dart:convert';

KandangModel kandangModelFromJson(String str) =>
    KandangModel.fromJson(json.decode(str));

String kandangModelToJson(KandangModel data) => json.encode(data.toJson());

class KandangModel {
  KandangModel({
    required this.id,
    required this.shedName,
    required this.shedId,
    required this.numberOfCattle,
    required this.weigthOfCattle,
  });

  String id;
  String shedName;
  String shedId;
  int numberOfCattle;
  int weigthOfCattle;

  factory KandangModel.fromJson(Map<String, dynamic> json) => KandangModel(
        id: json["id"],
        shedName: json["shed_name"] ?? "",
        shedId: json["shed_id"] ?? "",
        numberOfCattle: json["number_of_cattle"] ?? 0,
        weigthOfCattle: json["weigth_of_cattle"] ?? 0,
      );

  static List<KandangModel> fromJsonList(List list) {
    if (list.length == 0) return List<KandangModel>.empty();
    return list.map((item) => KandangModel.fromJson(item)).toList();
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "shed_name": shedName,
        "shed_id": shedId,
        "number_of_cattle": numberOfCattle,
        "weigth_of_cattle": weigthOfCattle,
      };
}

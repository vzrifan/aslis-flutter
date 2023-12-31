// To parse this JSON data, do
//
//     final detailKandangModel = detailKandangModelFromJson(jsonString);

import 'dart:convert';

DetailKandangModel detailKandangModelFromJson(String str) =>
    DetailKandangModel.fromJson(json.decode(str));

String detailKandangModelToJson(DetailKandangModel data) =>
    json.encode(data.toJson());

class DetailKandangModel {
  DetailKandangModel({
    required this.id,
    required this.shedId,
    required this.shedName,
    required this.address,
    required this.idProvince,
    required this.idCity,
    required this.capacity,
    required this.numberOfCattle,
    required this.weigthOfCattle,
    required this.city,
    required this.province,
  });

  String id;
  String shedId;
  String shedName;
  String address;
  int idProvince;
  int idCity;
  int capacity;
  int numberOfCattle;
  String weigthOfCattle;
  String city;
  String province;

  factory DetailKandangModel.fromJson(Map<String, dynamic> json) =>
      DetailKandangModel(
        id: json["id"],
        shedId: json["shed_id"] ?? "",
        shedName: json["shed_name"] ?? "",
        address: json["address"] ?? "",
        idProvince: json["id_province"] ?? 0,
        idCity: json["id_city"] ?? 0,
        capacity: json["capacity"] ?? 0,
        numberOfCattle: json["number_of_cattle"] ?? 0,
        weigthOfCattle: json["weigth_of_cattle"].toString(),
        city: json["city"] ?? "",
        province: json["province"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "shed_id": shedId,
        "shed_name": shedName,
        "address": address,
        "id_province": idProvince,
        "id_city": idCity,
        "capacity": capacity,
        "number_of_cattle": numberOfCattle,
        "weigth_of_cattle": weigthOfCattle,
        "city": city,
        "province": province,
      };
}

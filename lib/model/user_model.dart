// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.status,
    required this.profile,
    required this.idCountry,
    required this.idProvince,
    required this.idCity,
    required this.idDistrict,
    required this.address,
    required this.gender,
    required this.farmerName,
    required this.city,
    required this.province,
    required this.district,
  });

  String id;
  String userName;
  String userEmail;
  String userPhone;
  int status;
  String profile;
  int idCountry;
  int idProvince;
  int idCity;
  int idDistrict;
  String address;
  int gender;
  String farmerName;
  String city;
  String province;
  String district;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"] ?? "",
        userName: json["user_name"] ?? "",
        userEmail: json["user_email"] ?? "",
        userPhone: json["user_phone"] ?? "",
        status: json["status"] ?? 0,
        profile: json["profile"] ?? "",
        idCountry: json["id_country"] ?? 0,
        idProvince: json["id_province"] ?? 0,
        idCity: json["id_city"] ?? 0,
        idDistrict: json["id_district"] ?? 0,
        address: json["address"] ?? "",
        gender: json["gender"] ?? 0,
        farmerName: json["farmer_name"] ?? "",
        city: json["city"] ?? "",
        province: json["province"] ?? "",
        district: json["district"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "user_email": userEmail,
        "user_phone": userPhone,
        "status": status,
        "profile": profile,
        "id_country": idCountry,
        "id_province": idProvince,
        "id_city": idCity,
        "id_district": idDistrict,
        "address": address,
        "gender": gender,
        "farmer_name": farmerName,
        "city": city,
        "province": province,
        "district": district,
      };
}

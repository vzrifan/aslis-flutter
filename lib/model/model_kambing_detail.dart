// To parse this JSON data, do
//
//     final detailKambingModel = detailKambingModelFromJson(jsonString);

import 'dart:convert';

DetailKambingModel detailKambingModelFromJson(String str) =>
    DetailKambingModel.fromJson(json.decode(str));

String detailKambingModelToJson(DetailKambingModel data) =>
    json.encode(data.toJson());

class DetailKambingModel {
  DetailKambingModel({
    required this.id,
    required this.cattleId,
    required this.cattleName,
    required this.type,
    required this.gender,
    required this.birthday,
    required this.purchaseDate,
    required this.idCategory,
    required this.maleParent,
    required this.femaleParent,
    required this.price,
    required this.weigth,
    required this.status,
    required this.idUser,
    // required this.photo,
    required this.age,
    required this.nama_kandang,
    required this.female_parent_name,
    required this.male_parent_name,
    required this.total_food,
    required this.total_fee_food,
    required this.total_growth_weigth,
    required this.final_price,
    required this.selling_price,
    required this.discount,
    required this.is_selling,
  });

  String id;
  String cattleId;
  String cattleName;
  int type;
  int gender;
  String birthday;
  String purchaseDate;
  String idCategory;
  String maleParent;
  String femaleParent;
  String price;
  String weigth;
  int status;
  String idUser;
  // String photo;
  String age;
  String nama_kandang;
  String male_parent_name;
  String female_parent_name;
  String total_food;
  String total_fee_food;
  String total_growth_weigth;
  String final_price;
  String selling_price;
  int discount;
  int is_selling;

  factory DetailKambingModel.fromJson(Map<String, dynamic> json) =>
      DetailKambingModel(
        id: json["id"],
        cattleId: json["cattle_id"] ?? "",
        cattleName: json["cattle_name"] ?? "",
        type: json["type"] ?? 0,
        gender: json["gender"] ?? 1,
        birthday: json["birthday"] ?? "",
        purchaseDate: json["purchase_date"] ?? "",
        idCategory: json["id_category"] ?? "",
        maleParent: json["male_parent"] ?? "",
        femaleParent: json["female_parent"] ?? "",
        price: json["price"] ?? "",
        weigth: json["weigth"] ?? "",
        status: json["status"] ?? 1,
        idUser: json["id_user"] ?? "",
        // photo: json["photo"] ?? "",
        age: json["age"] ?? "",
        nama_kandang: json["nama_kandang"] ?? "",
        male_parent_name: json["male_parent_name"] ?? "",
        female_parent_name: json["female_parent_name"] ?? "",
        total_food: json["total_food"].toString(),
        total_fee_food: json["total_fee_food"].toString(),
        total_growth_weigth: json["total_growth_weigth"].toString(),
        final_price: json["final_price"].toString(),
        selling_price: json["selling_price"].toString(),
        discount: json["discount"] ?? 0,
        is_selling: json['is_selling'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cattle_id": cattleId,
        "cattle_name": cattleName,
        "type": type,
        "gender": gender,
        "birthday": birthday,
        "purchase_date": purchaseDate,
        "id_category": idCategory,
        "male_parent": maleParent,
        "female_parent": femaleParent,
        "price": price,
        "weigth": weigth,
        "status": status,
        "id_user": idUser,
        // "photo": photo,
        "age": age,
        "nama_kandang": nama_kandang,
        "male_parent_name": male_parent_name,
        "female_parent_name": female_parent_name,
        "total_food": total_food,
        "total_fee_food": total_fee_food,
        "total_growth_weigth": total_growth_weigth,
        "selling_price": selling_price,
        "final_price": final_price,
        "discount": discount,
        "is_selling": is_selling,
      };
}

// To parse this JSON data, do
//
//     final detailPakanModel = detailPakanModelFromJson(jsonString);

import 'dart:convert';

DetailPakanModel detailPakanModelFromJson(String str) =>
    DetailPakanModel.fromJson(json.decode(str));

String detailPakanModelToJson(DetailPakanModel data) =>
    json.encode(data.toJson());

class DetailPakanModel {
  DetailPakanModel({
    required this.id,
    required this.foodName,
    required this.foodId,
    required this.date,
    required this.capitalPrice,
    required this.status,
    required this.price,
    required this.stock,
    required this.idCategory,
    required this.availableStock,
    required this.categoryName,
    required this.is_available,
    required this.total,
    required this.total_stock,
  });

  String id;
  String foodName;
  String foodId;
  String date;
  String capitalPrice;
  int status;
  String price;
  String stock;
  String idCategory;
  String availableStock;
  String categoryName;
  int is_available;
  String total;
  String total_stock;

  factory DetailPakanModel.fromJson(Map<String, dynamic> json) =>
      DetailPakanModel(
        id: json["id"] ?? "",
        foodName: json["food_name"] ?? "",
        foodId: json["food_id"] ?? "",
        date: json["date"] ?? "",
        capitalPrice: json["capital_price"] ?? "",
        status: json["status"] ?? 0,
        price: json["price"] ?? "",
        stock: json["stock"] ?? "",
        idCategory: json["id_category"] ?? "",
        availableStock: json["available_stock"] ?? "",
        categoryName: json["category_name"] ?? "",
        is_available: json["is_available"] ?? 0,
        total: json["total"] ?? "0",
        total_stock: json["total_stock"] ?? "0",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "food_name": foodName,
        "food_id": foodId,
        "date": date,
        "capital_price": capitalPrice,
        "status": status,
        "price": price,
        "stock": stock,
        "id_category": idCategory,
        "available_stock": availableStock,
        "category_name": categoryName,
        "is_available": is_available,
        "total": total,
        "total_stock": total_stock,
      };
}

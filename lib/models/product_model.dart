// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(
    json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.imageUrl,
    this.brandName,
    this.packageName,
    this.price,
    this.rating,
  });

  int? id;
  String? name;
  String? imageUrl;
  String? brandName;
  String? packageName;
  int? price;
  double? rating;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        imageUrl: json["image_url"],
        brandName: json["brand_name"],
        packageName: json["package_name"],
        price: json["price"],
        rating: json["rating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image_url": imageUrl,
        "brand_name": brandName,
        "package_name": packageName,
        "price": price,
        "rating": rating,
      };
}

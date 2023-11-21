// To parse this JSON data, do
//
//     final wishListModel = wishListModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_restaurant/data/model/response/product_model.dart';

WishListModel wishListModelFromJson(String str) => WishListModel.fromJson(json.decode(str));

String wishListModelToJson(WishListModel data) => json.encode(data.toJson());

class WishListModel {
  WishListModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.products,
  });

  int? totalSize;
  String? limit;
  String? offset;
  List<Product>? products;

  factory WishListModel.fromJson(Map<String, dynamic> json) => WishListModel(
    totalSize: json["total_size"],
    limit: json["limit"],
    offset: json["offset"],
    products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total_size": totalSize,
    "limit": limit,
    "offset": offset,
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
  };
}


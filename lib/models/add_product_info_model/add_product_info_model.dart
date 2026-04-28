import 'dart:convert';

AddProductInfoModel addProductInfoModelFromJson(String str) =>
    AddProductInfoModel.fromJson(json.decode(str));

String addProductInfoModelToJson(AddProductInfoModel data) =>
    json.encode(data.toJson());

class AddProductInfoModel {
  final String? message;
  final Data? data;

  AddProductInfoModel({
    this.message,
    this.data,
  });

  factory AddProductInfoModel.fromJson(Map<String, dynamic> json) =>
      AddProductInfoModel(
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  final List<Category>? categories;
  final List<Brand>? brands;
  final List<Unit>? units;
  final List<Tax>? taxs;
  final List<String>? barcodeSymbologyes;
  final List<String>? productTypes;
  final List<String>? taxMethods;

  Data({
    this.categories,
    this.brands,
    this.units,
    this.taxs,
    this.barcodeSymbologyes,
    this.productTypes,
    this.taxMethods,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        brands: json["brands"] == null
            ? []
            : List<Brand>.from(json["brands"]!.map((x) => Brand.fromJson(x))),
        units: json["units"] == null
            ? []
            : List<Unit>.from(json["units"]!.map((x) => Unit.fromJson(x))),
        taxs: json["taxs"] == null
            ? []
            : List<Tax>.from(json["taxs"]!.map((x) => Tax.fromJson(x))),
        barcodeSymbologyes: json["barcodeSymbologyes"] == null
            ? []
            : List<String>.from(json["barcodeSymbologyes"]!.map((x) => x)),
        productTypes: json["productTypes"] == null
            ? []
            : List<String>.from(json["productTypes"]!.map((x) => x)),
        taxMethods: json["taxMethods"] == null
            ? []
            : List<String>.from(json["taxMethods"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "brands": brands == null
            ? []
            : List<dynamic>.from(brands!.map((x) => x.toJson())),
        "units": units == null
            ? []
            : List<dynamic>.from(units!.map((x) => x.toJson())),
        "taxs": taxs == null
            ? []
            : List<dynamic>.from(taxs!.map((x) => x.toJson())),
        "barcodeSymbologyes": barcodeSymbologyes == null
            ? []
            : List<dynamic>.from(barcodeSymbologyes!.map((x) => x)),
        "productTypes": productTypes == null
            ? []
            : List<dynamic>.from(productTypes!.map((x) => x)),
        "taxMethods": taxMethods == null
            ? []
            : List<dynamic>.from(taxMethods!.map((x) => x)),
      };
}

class Brand {
  final int? id;
  final String? name;
  final String? thumbnail;
  final int? totalProducts;

  Brand({
    this.id,
    this.name,
    this.thumbnail,
    this.totalProducts,
  });

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        totalProducts: json["total_products"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "total_products": totalProducts,
      };
}

class Category {
  final int? id;
  final String? name;
  final String? thumbnail;
  final int? parentCategoryId;
  final String? parentCategoryName;
  final String? parentCategoryThumbnail;
  final int? totalProducts;

  Category({
    this.id,
    this.name,
    this.thumbnail,
    this.parentCategoryId,
    this.parentCategoryName,
    this.parentCategoryThumbnail,
    this.totalProducts,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        parentCategoryId: json["parent_category_id"],
        parentCategoryName: json["parent_category_name"],
        parentCategoryThumbnail: json["parent_category_thumbnail"],
        totalProducts: json["total_products"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "parent_category_id": parentCategoryId,
        "parent_category_name": parentCategoryName,
        "parent_category_thumbnail": parentCategoryThumbnail,
        "total_products": totalProducts,
      };
}

class Tax {
  final int? id;
  final String? name;
  final double? rate;

  Tax({
    this.id,
    this.name,
    this.rate,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        id: json["id"],
        name: json["name"],
        rate: json["rate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rate": rate,
      };
}

class Unit {
  final int? id;
  final String? name;

  Unit({
    this.id,
    this.name,
  });

  factory Unit.fromJson(Map<String, dynamic> json) => Unit(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class HiveCartModel {
  int id;
  String code;
  String name;
  String thumbnail;
  double subTotal;
  int productsQTY;

  HiveCartModel({
    required this.id,
    required this.code,
    required this.name,
    required this.thumbnail,
    required this.subTotal,
    required this.productsQTY,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'code': code,
      'name': name,
      'thumbnail': thumbnail,
      'subtotal': subTotal,
      'productsQTY': productsQTY,
    };
  }

  factory HiveCartModel.fromMap(Map<dynamic, dynamic> map) {
    return HiveCartModel(
      id: map['id'] as int,
      code: map['code'] as String,
      name: map['name'] as String,
      thumbnail: map['thumbnail'] as String,
      subTotal: map['subtotal'] as double,
      productsQTY: map['productsQTY'] as int,
    );
  }

  HiveCartModel copyWith({
    int? id,
    String? code,
    String? name,
    String? thumbnail,
    double? subTotal,
    int? productsQTY,
  }) {
    return HiveCartModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      subTotal: subTotal ?? this.subTotal,
      productsQTY: productsQTY ?? this.productsQTY,
    );
  }

  String toJson() => json.encode(toMap());

  factory HiveCartModel.fromJson(String source) =>
      HiveCartModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class HiveCartModelAdapter extends TypeAdapter<HiveCartModel> {
  @override
  final typeId = 0;

  @override
  HiveCartModel read(BinaryReader reader) {
    return HiveCartModel.fromMap(reader.readMap());
  }

  @override
  void write(BinaryWriter writer, HiveCartModel obj) {
    writer.writeMap(obj.toMap());
  }
}

import 'dart:convert';

class PosProductModel {
  int? id;
  String? name;
  String? code;
  int? qty;
  double? stock;
  String? thumbnail;
  String? endingDate;
  double? price;
  double? cost;
  double? discount;
  double? tax;
  double? subtotal;
  bool? batch;

  PosProductModel({
    this.id,
    this.name,
    this.code,
    this.qty,
    this.stock,
    this.thumbnail,
    this.endingDate,
    this.price,
    this.cost,
    this.discount,
    this.tax,
    this.subtotal,
    this.batch,
  });

  factory PosProductModel.fromMap(Map<String, dynamic> data) => PosProductModel(
        id: data['id'] as int?,
        name: data['name'] as String?,
        code: data['code'] as String?,
        qty: data['qty'] as int?,
        stock: data['stock'] as double?,
        thumbnail: data['thumbnail'] as String?,
        endingDate: data['ending_date'] as String?,
        price: (data['price'] as num?)?.toDouble(),
        cost: (data['cost'] as num?)?.toDouble(),
        discount: (data['discount'] as num?)?.toDouble(),
        tax: (data['tax'] as num?)?.toDouble(),
        subtotal: (data['subtotal'] as num?)?.toDouble(),
        batch: data['batch'] as bool?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'code': code,
        'qty': qty,
        'stock': stock,
        'thumbnail': thumbnail,
        'ending_date': endingDate,
        'price': price,
        'cost': cost,
        'discount': discount,
        'tax': tax,
        'subtotal': subtotal,
        'batch': batch,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PosProductModel].
  factory PosProductModel.fromJson(String data) {
    return PosProductModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PosProductModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

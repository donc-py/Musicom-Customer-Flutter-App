import 'dart:convert';

class SalesModel {
  int? id;
  String? date;
  String? referenceNo;
  String? biller;
  int? qty;
  double? discount;
  double? tax;
  double? totalPrice;
  double? grandTotal;

  SalesModel({
    this.id,
    this.date,
    this.referenceNo,
    this.biller,
    this.qty,
    this.discount,
    this.tax,
    this.totalPrice,
    this.grandTotal,
  });

  factory SalesModel.fromMap(Map<String, dynamic> data) => SalesModel(
        id: data['id'] as int?,
        date: data['date'] as String?,
        referenceNo: data['reference_no'] as String?,
        biller: data['biller'] as String?,
        qty: data['qty'] as int?,
        discount: data['discount'] as double?,
        tax: (data['tax'] as num?)?.toDouble(),
        totalPrice: (data['total_price'] as num?)?.toDouble(),
        grandTotal: (data['grand_total'] as num?)?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'reference_no': referenceNo,
        'biller': biller,
        'qty': qty,
        'discount': discount,
        'tax': tax,
        'total_price': totalPrice,
        'grand_total': grandTotal,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SalesModel].
  factory SalesModel.fromJson(String data) {
    return SalesModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [SalesModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

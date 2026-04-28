import 'dart:convert';
import 'package:readypos_flutter/models/draft_model/customer.dart';
import 'product.dart';

class Draft {
  int? id;
  List<Product>? products;
  int? totalProduct;
  double? discount;
  double? tax;
  double? totalPrice;
  String? paymentMethod;
  double? grandTotal;
  Customer? customer;
  String? createdAt;
  String? time;

  Draft({
    this.id,
    this.products,
    this.totalProduct,
    this.discount,
    this.tax,
    this.totalPrice,
    this.paymentMethod,
    this.grandTotal,
    this.customer,
    this.createdAt,
    this.time,
  });

  factory Draft.fromMap(Map<String, dynamic> data) => Draft(
        id: data['id'] as int?,
        products: (data['products'] as List<dynamic>?)
            ?.map((e) => Product.fromMap(e as Map<String, dynamic>))
            .toList(),
        totalProduct: data['total_product'] as int?,
        discount: data['discount'] as double?,
        tax: data['tax'] as double?,
        totalPrice: data['total_price'] as double?,
        paymentMethod: data['payment_method'] as String?,
        grandTotal: data['grand_total'] as double?,
        customer: data['customer'] == null
            ? null
            : Customer.fromMap(data['customer'] as Map<String, dynamic>),
        createdAt: data['created_at'] as String?,
        time: data['time'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'products': products?.map((e) => e.toMap()).toList(),
        'total_product': totalProduct,
        'discount': discount,
        'tax': tax,
        'total_price': totalPrice,
        'payment_method': paymentMethod,
        'grand_total': grandTotal,
        'customer': customer?.toMap(),
        'created_at': createdAt,
        'time': time,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Draft].
  factory Draft.fromJson(String data) {
    return Draft.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Draft] to a JSON string.
  String toJson() => json.encode(toMap());
}

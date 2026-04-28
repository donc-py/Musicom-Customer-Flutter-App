import 'dart:convert';

class Product {
  int? id;
  String? name;
  String? thumbnail;
  String? brand;
  String? category;
  String? unit;
  double? price;
  int? stock;
  String? code;
  double? tax;
  double? subTotal;
  int? quantity;

  Product({
    this.id,
    this.name,
    this.thumbnail,
    this.brand,
    this.category,
    this.unit,
    this.price,
    this.stock,
    this.code,
    this.tax,
    this.subTotal,
    this.quantity,
  });

  factory Product.fromMap(Map<String, dynamic> data) => Product(
        id: data['id'] as int?,
        name: data['name'] as String?,
        thumbnail: data['thumbnail'] as String?,
        brand: data['brand'] as String?,
        category: data['category'] as String?,
        unit: data['unit'] as String?,
        price: data['price'] as double?,
        stock: data['stock'] as int?,
        code: data['code'] as String?,
        tax: data['tax'] as double?,
        subTotal: data['sub_total'] as double?,
        quantity: data['quantity'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'thumbnail': thumbnail,
        'brand': brand,
        'category': category,
        'unit': unit,
        'price': price,
        'stock': stock,
        'code': code,
        'tax': tax,
        'sub_total': subTotal,
        'quantity': quantity,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Product].
  factory Product.fromJson(String data) {
    return Product.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Product] to a JSON string.
  String toJson() => json.encode(toMap());
}

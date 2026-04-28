import 'dart:convert';

class Product {
  final int id;
  final String? name;
  final String? thumbnail;
  final String? brand;
  final String? category;
  final String? unit;
  final double? price;
  final int? qty;
  final String? code;
  Product({
    required this.id,
    this.name,
    this.thumbnail,
    this.brand,
    this.category,
    this.unit,
    this.price,
    this.qty,
    this.code,
  });

  Product copyWith({
    int? id,
    String? name,
    String? thumbnail,
    String? brand,
    String? category,
    String? unit,
    double? price,
    int? qty,
    String? code,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      code: code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumbnail': thumbnail,
      'brand': brand,
      'category': category,
      'unit': unit,
      'price': price,
      'qty': qty,
      'code': code,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String?,
      thumbnail: map['thumbnail'] as String?,
      brand: map['brand'] as String?,
      category: map['category'] as String?,
      unit: map['unit'] as String?,
      price: map['price'] as double?,
      qty: map['qty'] as int?,
      code: map['code'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Product(id: $id, name: $name, thumbnail: $thumbnail, brand: $brand, category: $category, unit: $unit, price: $price, qty: $qty, code: $code)';
  }

  @override
  bool operator ==(covariant Product other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.thumbnail == thumbnail &&
        other.brand == brand &&
        other.category == category &&
        other.unit == unit &&
        other.price == price &&
        other.qty == qty &&
        other.code == code;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        thumbnail.hashCode ^
        brand.hashCode ^
        category.hashCode ^
        unit.hashCode ^
        price.hashCode ^
        qty.hashCode ^
        code.hashCode;
  }
}

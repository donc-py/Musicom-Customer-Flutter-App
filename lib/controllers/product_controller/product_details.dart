import 'dart:convert';

class ProductDetails {
  final int id;
  final String? name;
  final String? thumbnail;
  final String? brand;
  final String? category;
  final String? unit;
  final int? qty;
  final int? alertQty;
  final String? code;
  final String? productType;
  final double? purchaseCost;
  final double? price;
  final String? description;
  ProductDetails({
    required this.id,
    this.name,
    this.thumbnail,
    this.brand,
    this.category,
    this.unit,
    this.qty,
    this.alertQty,
    this.code,
    this.productType,
    this.purchaseCost,
    this.price,
    this.description,
  });

  ProductDetails copyWith({
    int? id,
    String? name,
    String? thumbnail,
    String? brand,
    String? category,
    String? unit,
    int? qty,
    int? alertQty,
    String? code,
    String? productType,
    double? purchaseCost,
    double? price,
    String? description,
  }) {
    return ProductDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      thumbnail: thumbnail ?? this.thumbnail,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      qty: qty ?? this.qty,
      alertQty: alertQty ?? this.alertQty,
      code: code ?? this.code,
      productType: productType ?? this.productType,
      purchaseCost: purchaseCost ?? this.purchaseCost,
      price: price ?? this.price,
      description: description ?? this.description,
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
      'qty': qty,
      'alert_qty': alertQty,
      'code': code,
      'product_type': productType,
      'purchase_cost': purchaseCost,
      'price': price,
      'description': description,
    };
  }

  factory ProductDetails.fromMap(Map<String, dynamic> map) {
    return ProductDetails(
      id: map['id'] as int,
      name: map['name'] as String?,
      thumbnail: map['thumbnail'] as String?,
      brand: map['brand'] as String?,
      category: map['category'] as String?,
      unit: map['unit'] as String?,
      qty: map['qty'] as int?,
      alertQty: map['alert_qty'] as int?,
      code: map['code'] as String?,
      productType: map['product_type'] as String?,
      purchaseCost: map['purchase_cost'] as double?,
      price: map['price'] as double?,
      description: map['description'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductDetails.fromJson(String source) =>
      ProductDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductDetails(id: $id, name: $name, thumbnail: $thumbnail, brand: $brand, category: $category, unit: $unit, qty: $qty, alertQty: $alertQty, code: $code, productType: $productType, purchaseCost: $purchaseCost, price: $price, description: $description)';
  }

  @override
  bool operator ==(covariant ProductDetails other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.thumbnail == thumbnail &&
        other.brand == brand &&
        other.category == category &&
        other.unit == unit &&
        other.qty == qty &&
        other.alertQty == alertQty &&
        other.code == code &&
        other.productType == productType &&
        other.purchaseCost == purchaseCost &&
        other.price == price &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        thumbnail.hashCode ^
        brand.hashCode ^
        category.hashCode ^
        unit.hashCode ^
        qty.hashCode ^
        alertQty.hashCode ^
        code.hashCode ^
        productType.hashCode ^
        purchaseCost.hashCode ^
        price.hashCode ^
        description.hashCode;
  }
}

class PosOrderModel {
  final int id;
  final String orderCode;
  final String orderStatus;
  final String paymentStatus;
  final String paymentMethod;
  final double totalAmount;
  final double payableAmount;
  final String createdAt;
  final List<PosOrderProduct> products;

  PosOrderModel({
    required this.id,
    required this.orderCode,
    required this.orderStatus,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.totalAmount,
    required this.payableAmount,
    required this.createdAt,
    required this.products,
  });

  factory PosOrderModel.fromMap(Map<String, dynamic> map) {
    return PosOrderModel(
      id:            map['id'] ?? 0,
      orderCode:     map['order_code'] ?? '',
      orderStatus:   map['order_status']?.toString() ?? '',
      paymentStatus: map['payment_status']?.toString() ?? '',
      paymentMethod: map['payment_method']?.toString() ?? '',
      totalAmount:   (map['total_amount'] ?? 0).toDouble(),
      payableAmount: (map['payable_amount'] ?? 0).toDouble(),
      createdAt:     map['created_at'] ?? '',
      products: (map['products'] as List<dynamic>? ?? [])
          .map((e) => PosOrderProduct.fromMap(e))
          .toList(),
    );
  }
}

class PosOrderProduct {
  final int id;
  final String name;
  final String thumbnail;
  final int quantity;
  final double price;

  PosOrderProduct({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.quantity,
    required this.price,
  });

  factory PosOrderProduct.fromMap(Map<String, dynamic> map) {
    return PosOrderProduct(
      id:        map['id'] ?? 0,
      name:      map['name'] ?? '',
      thumbnail: map['thumbnail'] ?? '',
      quantity:  map['quantity'] ?? 0,
      price:     (map['price'] ?? 0).toDouble(),
    );
  }
}
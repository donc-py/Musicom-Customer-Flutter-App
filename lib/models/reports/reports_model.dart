import 'dart:convert';

class Report {
  final Purchases purchases;
  final Sales sales;
  final PaymentReceived paymentReceived;
  final int profit;
  Report({
    required this.purchases,
    required this.sales,
    required this.paymentReceived,
    required this.profit,
  });

  Report copyWith({
    Purchases? purchases,
    Sales? sales,
    PaymentReceived? paymentReceived,
    int? profit,
  }) {
    return Report(
      purchases: purchases ?? this.purchases,
      sales: sales ?? this.sales,
      paymentReceived: paymentReceived ?? this.paymentReceived,
      profit: profit ?? this.profit,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'purchases': purchases.toMap(),
      'sales': sales.toMap(),
      'paymentReceived': paymentReceived.toMap(),
      'profit': profit,
    };
  }

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      purchases: Purchases.fromMap(map['purchases'] as Map<String, dynamic>),
      sales: Sales.fromMap(map['sales'] as Map<String, dynamic>),
      paymentReceived: PaymentReceived.fromMap(
          map['payment_received'] as Map<String, dynamic>),
      profit: map['profit'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Report.fromJson(String source) =>
      Report.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Report(purchases: $purchases, sales: $sales, payment_received: $paymentReceived, profit: $profit)';
  }

  @override
  bool operator ==(covariant Report other) {
    if (identical(this, other)) return true;

    return other.purchases == purchases &&
        other.sales == sales &&
        other.paymentReceived == paymentReceived &&
        other.profit == profit;
  }

  @override
  int get hashCode {
    return purchases.hashCode ^
        sales.hashCode ^
        paymentReceived.hashCode ^
        profit.hashCode;
  }
}

class Purchases {
  final int total;
  final int paid;
  final int tax;
  final int discount;
  final int due;
  final int products;
  Purchases({
    required this.total,
    required this.paid,
    required this.tax,
    required this.discount,
    required this.due,
    required this.products,
  });

  Purchases copyWith({
    int? total,
    int? paid,
    int? tax,
    int? discount,
    int? due,
    int? products,
  }) {
    return Purchases(
      total: total ?? this.total,
      paid: paid ?? this.paid,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      due: due ?? this.due,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'paid': paid,
      'tax': tax,
      'discount': discount,
      'due': due,
      'products': products,
    };
  }

  factory Purchases.fromMap(Map<String, dynamic> map) {
    return Purchases(
      total: map['total'].toInt() as int,
      paid: map['paid'].toInt() as int,
      tax: map['tax'].toInt() as int,
      discount: map['discount'].toInt() as int,
      due: map['due'].toInt() as int,
      products: map['products'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Purchases.fromJson(String source) =>
      Purchases.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Purchases(total: $total, paid: $paid, tax: $tax, discount: $discount, due: $due, products: $products)';
  }

  @override
  bool operator ==(covariant Purchases other) {
    if (identical(this, other)) return true;

    return other.total == total &&
        other.paid == paid &&
        other.tax == tax &&
        other.discount == discount &&
        other.due == due &&
        other.products == products;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        paid.hashCode ^
        tax.hashCode ^
        discount.hashCode ^
        due.hashCode ^
        products.hashCode;
  }
}

class Sales {
  final int total;
  final int tax;
  final int discount;
  final int sellingProduct;
  final int availableProduct;
  Sales({
    required this.total,
    required this.tax,
    required this.discount,
    required this.sellingProduct,
    required this.availableProduct,
  });

  Sales copyWith({
    int? total,
    int? tax,
    int? discount,
    int? sellingProduct,
    int? availableProduct,
  }) {
    return Sales(
      total: total ?? this.total,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      sellingProduct: sellingProduct ?? this.sellingProduct,
      availableProduct: availableProduct ?? this.availableProduct,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'tax': tax,
      'discount': discount,
      'selling_product': sellingProduct,
      'available_product': availableProduct,
    };
  }

  factory Sales.fromMap(Map<String, dynamic> map) {
    return Sales(
      total: map['total'].toInt() as int,
      tax: map['tax'].toInt() as int,
      discount: map['discount'].toInt() as int,
      sellingProduct: map['selling_product'].toInt() as int,
      availableProduct: map['available_product'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Sales.fromJson(String source) =>
      Sales.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Sales(total: $total, tax: $tax, discount: $discount, sellingProduct: $sellingProduct, availableProduct: $availableProduct)';
  }

  @override
  bool operator ==(covariant Sales other) {
    if (identical(this, other)) return true;

    return other.total == total &&
        other.tax == tax &&
        other.discount == discount &&
        other.sellingProduct == sellingProduct &&
        other.availableProduct == availableProduct;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        tax.hashCode ^
        discount.hashCode ^
        sellingProduct.hashCode ^
        availableProduct.hashCode;
  }
}

class PaymentReceived {
  final int total;
  final int cash;
  final int bank;
  final int cashCount;
  final int bankCount;
  PaymentReceived({
    required this.total,
    required this.cash,
    required this.bank,
    required this.cashCount,
    required this.bankCount,
  });

  PaymentReceived copyWith({
    int? total,
    int? cash,
    int? bank,
    int? cashCount,
    int? bankCount,
  }) {
    return PaymentReceived(
      total: total ?? this.total,
      cash: cash ?? this.cash,
      bank: bank ?? this.bank,
      cashCount: cashCount ?? this.cashCount,
      bankCount: bankCount ?? this.bankCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total': total,
      'cash': cash,
      'bank': bank,
      'cash_count': cashCount,
      'bank_count': bankCount,
    };
  }

  factory PaymentReceived.fromMap(Map<String, dynamic> map) {
    return PaymentReceived(
      total: map['total'].toInt() as int,
      cash: map['cash'].toInt() as int,
      bank: map['bank'].toInt() as int,
      cashCount: map['cash_count'].toInt() as int,
      bankCount: map['bank_count'].toInt() as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentReceived.fromJson(String source) =>
      PaymentReceived.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PaymentReceived(total: $total, cash: $cash, bank: $bank, cashCount: $cashCount, bankCount: $bankCount)';
  }

  @override
  bool operator ==(covariant PaymentReceived other) {
    if (identical(this, other)) return true;

    return other.total == total &&
        other.cash == cash &&
        other.bank == bank &&
        other.cashCount == cashCount &&
        other.bankCount == bankCount;
  }

  @override
  int get hashCode {
    return total.hashCode ^
        cash.hashCode ^
        bank.hashCode ^
        cashCount.hashCode ^
        bankCount.hashCode;
  }
}

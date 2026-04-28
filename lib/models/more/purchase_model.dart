import 'dart:convert';

class PurchaseModel {
  int? id;
  String? date;
  String? referenceNo;
  String? supplier;
  double? grandTotal;
  double? paidAmount;
  double? dueAmount;
  String? status;

  PurchaseModel({
    this.id,
    this.date,
    this.referenceNo,
    this.supplier,
    this.grandTotal,
    this.paidAmount,
    this.dueAmount,
    this.status,
  });

  factory PurchaseModel.fromMap(Map<String, dynamic> data) => PurchaseModel(
        id: data['id'] as int?,
        date: data['date'] as String?,
        referenceNo: data['reference_no'] as String?,
        supplier: data['supplier'] as String?,
        grandTotal: data['grand_total'] as double?,
        paidAmount: data['paid_amount'] as double?,
        dueAmount: data['due_amount'] as double?,
        status: data['status'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'reference_no': referenceNo,
        'supplier': supplier,
        'grand_total': grandTotal,
        'paid_amount': paidAmount,
        'due_amount': dueAmount,
        'status': status,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [PurchaseModel].
  factory PurchaseModel.fromJson(String data) {
    return PurchaseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [PurchaseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

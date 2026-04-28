import 'dart:convert';

class ExpenseModel {
  int? id;
  String? date;
  String? referenceNo;
  String? wearehouse;
  String? category;
  double? amount;
  String? note;

  ExpenseModel({
    this.id,
    this.date,
    this.referenceNo,
    this.wearehouse,
    this.category,
    this.amount,
    this.note,
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> data) => ExpenseModel(
        id: data['id'] as int?,
        date: data['date'] as String?,
        referenceNo: data['reference_no'] as String?,
        wearehouse: data['wearehouse'] as String?,
        category: data['category'] as String?,
        amount: data['amount'] as double?,
        note: data['note'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'reference_no': referenceNo,
        'wearehouse': wearehouse,
        'category': category,
        'amount': amount,
        'note': note,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ExpenseModel].
  factory ExpenseModel.fromJson(String data) {
    return ExpenseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ExpenseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

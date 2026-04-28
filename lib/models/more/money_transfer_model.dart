import 'dart:convert';

class MoneyTransferModel {
  int? id;
  String? date;
  String? referenceNo;
  String? from;
  String? to;
  double? amount;

  MoneyTransferModel({
    this.id,
    this.date,
    this.referenceNo,
    this.from,
    this.to,
    this.amount,
  });

  factory MoneyTransferModel.fromMap(Map<String, dynamic> data) {
    return MoneyTransferModel(
      id: data['id'] as int?,
      date: data['date'] as String?,
      referenceNo: data['reference_no'] as String?,
      from: data['from'] as String?,
      to: data['to'] as String?,
      amount: data['amount'] as double?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': date,
        'reference_no': referenceNo,
        'from': from,
        'to': to,
        'amount': amount,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MoneyTransferModel].
  factory MoneyTransferModel.fromJson(String data) {
    return MoneyTransferModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MoneyTransferModel] to a JSON string.
  String toJson() => json.encode(toMap());
}

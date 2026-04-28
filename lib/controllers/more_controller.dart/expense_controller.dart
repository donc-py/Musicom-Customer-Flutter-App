import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:readypos_flutter/models/more/expense_model.dart';
import 'package:readypos_flutter/services/more_service_provider.dart';

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, bool>((ref) {
  return ExpenseController(ref);
});

class ExpenseController extends StateNotifier<bool> {
  final Ref ref;
  ExpenseController(this.ref) : super(false);

  List<ExpenseModel> _expenseList = [];
  double _totalExpense = 0.0;
  int _totalData = 0;
  List<ExpenseModel> get expenseList => _expenseList;
  double get totalExpense => _totalExpense;
  int get totalData => _totalData;

  Future<void> getExpense(
      {int? page, int perPage = 20, String? searchQuery}) async {
    try {
      state = true;
      final response = searchQuery != null
          ? await ref
              .read(moreServiceProvider)
              .getExpenses(query: {'search': searchQuery})
          : await ref.read(moreServiceProvider).getExpenses(query: {
              'page': page,
              'per_page': perPage,
            });
      _expenseList = [];
      _totalExpense = response.data['data']['total_expense_amount'];
      final List<dynamic> expenseData = response.data['data']['expenses'];
      _totalData = response.data['data']['total'];
      if (expenseData.isNotEmpty) {
        // _expenseList = expenseData.map((e) => SalesModel.fromMap(e)).toList();
        _expenseList = await compute(parseExpense, expenseData);
      }
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> filterSales({required Map<String, dynamic> query}) async {
    try {
      state = true;
      final response =
          await ref.read(moreServiceProvider).getExpenses(query: query);
      _expenseList = [];
      _totalExpense = response.data['data']['total_expense_amount'];
      final List<dynamic> salesData = response.data['data']['expenses'];
      _totalData = response.data['data']['total'];
      if (salesData.isNotEmpty) {
        _expenseList = salesData.map((e) => ExpenseModel.fromMap(e)).toList();
      }
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }
}

List<ExpenseModel> parseExpense(List<dynamic> data) {
  return data
      .map((e) => ExpenseModel.fromMap(e as Map<String, dynamic>))
      .toList();
}

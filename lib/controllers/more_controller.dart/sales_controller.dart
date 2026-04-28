import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/more/sales_model.dart';
import 'package:readypos_flutter/services/more_service_provider.dart';

final salesControllerProvider =
    StateNotifierProvider<SalesController, bool>((ref) {
  return SalesController(ref);
});

final salesPDFProvider =
    NotifierProvider.autoDispose<SalesPDFProvider, bool>(SalesPDFProvider.new);

class SalesController extends StateNotifier<bool> {
  final Ref ref;
  SalesController(this.ref) : super(false);

  List<SalesModel> _salesList = [];
  int _totalData = 0;
  List<SalesModel> get salesList => _salesList;
  int get totalData => _totalData;

  Future<void> getSales(
      {int? page, int perPage = 20, String? searchQuery}) async {
    try {
      state = true;
      final response = searchQuery != null
          ? await ref
              .read(moreServiceProvider)
              .getSales(query: {'search': searchQuery})
          : await ref.read(moreServiceProvider).getSales(query: {
              'page': page,
              'per_page': perPage,
            });
      _salesList = [];
      final List<dynamic> salesData = response.data['data']['sales'];
      _totalData = response.data['data']['total'];
      if (salesData.isNotEmpty) {
        // _salesList = salesData.map((e) => SalesModel.fromMap(e)).toList();
        _salesList = await compute(parseSalesList, salesData);
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
          await ref.read(moreServiceProvider).getSales(query: query);
      _salesList = [];
      final List<dynamic> salesData = response.data['data']['sales'];
      _totalData = response.data['data']['total'];
      if (salesData.isNotEmpty) {
        _salesList = salesData.map((e) => SalesModel.fromMap(e)).toList();
      }
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }
}

List<SalesModel> parseSalesList(List<dynamic> salesData) {
  return salesData.map((e) => parseSales(e as Map<String, dynamic>)).toList();
}

SalesModel parseSales(Map<String, dynamic> sales) {
  return SalesModel.fromMap(sales);
}

class SalesPDFProvider extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<String?> getSalesPDF({required Map<String, dynamic> data}) async {
    try {
      state = true;
      final response =
          await ref.read(moreServiceProvider).getSalesPDF(data: data);
      state = false;
      return response.data['data']['invoice_pdf_url'];
    } catch (e) {
      state = false;
      return null;
    }
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/more/purchase_model.dart';
import 'package:readypos_flutter/services/more_service_provider.dart';

final purchaseControllerProvider =
    StateNotifierProvider<PurchaseController, bool>((ref) {
  return PurchaseController(ref);
});

final purchasePDFProvider =
    NotifierProvider.autoDispose<PurchasePDFProvider, bool>(
        PurchasePDFProvider.new);

class PurchaseController extends StateNotifier<bool> {
  final Ref ref;
  PurchaseController(this.ref) : super(false);

  List<PurchaseModel> _purchaseList = [];
  int _totalData = 0;
  List<PurchaseModel> get purchaseList => _purchaseList;
  int get totalData => _totalData;

  Future<void> getPurchase(
      {int? page, int perPage = 20, String? searchQuery}) async {
    try {
      state = true;
      final response = searchQuery != null
          ? await ref
              .read(moreServiceProvider)
              .getPurchase(query: {'search': searchQuery})
          : await ref.read(moreServiceProvider).getPurchase(query: {
              'page': page,
              'per_page': perPage,
            });
      _purchaseList = [];
      final List<dynamic> purchasesData = response.data['data']['purchases'];
      _totalData = response.data['data']['total'];
      if (purchasesData.isNotEmpty) {
        _purchaseList =
            purchasesData.map((e) => PurchaseModel.fromMap(e)).toList();
      }
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> filterPurchase({required Map<String, dynamic> query}) async {
    try {
      state = true;
      final response =
          await ref.read(moreServiceProvider).getPurchase(query: query);
      _purchaseList = [];
      final List<dynamic> productsData = response.data['data']['purchases'];
      _totalData = response.data['data']['total'];
      if (productsData.isNotEmpty) {
        _purchaseList =
            productsData.map((e) => PurchaseModel.fromMap(e)).toList();
      }
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }
}

class PurchasePDFProvider extends AutoDisposeNotifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<String?> getPurchasePDF({required Map<String, dynamic> data}) async {
    try {
      state = true;
      final response =
          await ref.read(moreServiceProvider).getPurchasePDF(data: data);
      state = false;
      return response.data['data']['invoice_pdf_url'];
    } catch (e) {
      state = false;
      return null;
    }
  }
}

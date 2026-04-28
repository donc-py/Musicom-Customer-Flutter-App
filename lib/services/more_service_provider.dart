import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final moreServiceProvider = Provider<MoreService>((ref) {
  return MoreService(ref);
});

abstract class MoreRepository {
  Future<Response> getPurchase({required Map<String, dynamic> query});
  Future<Response> getWareHouses();
  Future<Response> getSales({required Map<String, dynamic> query});
  Future<Response> getExpenses({required Map<String, dynamic> query});
  Future<Response> getAccounts({required Map<String, dynamic> query});
  Future<Response> getPurchasePDF({required Map<String, dynamic> data});
  Future<Response> getSalesPDF({required Map<String, dynamic> data});
}

class MoreService implements MoreRepository {
  final Ref ref;
  MoreService(this.ref);

  @override
  Future<Response> getPurchase({required Map<String, dynamic> query}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.purchase, query: query);
    return response;
  }

  @override
  Future<Response> getWareHouses() {
    final response = ref.read(apiClientProvider).get(AppConstants.wareHouse);
    return response;
  }

  @override
  Future<Response> getSales({required Map<String, dynamic> query}) {
    final response =
        ref.read(apiClientProvider).get(AppConstants.sales, query: query);
    return response;
  }

  @override
  Future<Response> getExpenses({required Map<String, dynamic> query}) {
    final response =
        ref.read(apiClientProvider).get(AppConstants.expenses, query: query);
    return response;
  }

  @override
  Future<Response> getAccounts({required Map<String, dynamic> query}) {
    final response =
        ref.read(apiClientProvider).get(AppConstants.accounts, query: query);
    return response;
  }

  @override
  Future<Response> getPurchasePDF({required Map<String, dynamic> data}) {
    final response =
        ref.read(apiClientProvider).get(AppConstants.purchasePDF, query: data);
    return response;
  }

  @override
  Future<Response> getSalesPDF({required Map<String, dynamic> data}) {
    final response =
        ref.read(apiClientProvider).get(AppConstants.salesPDF, query: data);
    return response;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final posProductsServiceProvider = Provider((ref) => PosProductsService(ref));

abstract class PosProductsRepository {
  Future<Response> getPosProducts(
      {String? search, String? categoryId, String? brandId});
  Future<Response> getSearchedProducts({required String barCode});
  Future<Response> cuponApply({required Map<String, dynamic> data});
}

class PosProductsService implements PosProductsRepository {
  final Ref ref;

  PosProductsService(this.ref);

  @override
  Future<Response> getPosProducts(
      {String? search, String? categoryId, String? brandId}) async {
    final response =
        await ref.read(apiClientProvider).get(AppConstants.posProducts, query: {
      'search': search,
      'category_id': categoryId,
      'brand_id': brandId,
    });
    return response;
  }

  @override
  Future<Response> getSearchedProducts({required String barCode}) {
    final response = ref.read(apiClientProvider).get(
      AppConstants.posProducts,
      query: {'search': barCode},
    );
    return response;
  }

  @override
  Future<Response> cuponApply({required Map<String, dynamic> data}) {
    final response = ref.read(apiClientProvider).post(
          AppConstants.cupon,
          data: data,
        );
    return response;
  }
}

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final productServiceProvider = Provider((ref) => ProductService(ref));

abstract class ProductRepository {
  Future<Response> getProducts(
      {required String? search, required int? perPage, required int? page});

  Future<Response> getProductDetails({required int orderId});
  Future<Response> deleteProduct({required int id});
  Future<Response> productInfo();
  Future<Response> addProduct({required Map<String, dynamic> data});
}

class ProductService implements ProductRepository {
  final Ref ref;
  ProductService(this.ref);
  @override
  Future<Response> getProducts({
    required String? search,
    required int? perPage,
    required int? page,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null) queryParams['search'] = search;
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;

    if (search != null) {}
    final response = await ref.read(apiClientProvider).get(
          AppConstants.products,
          query: queryParams,
        );
    return response;
  }

  @override
  Future<Response> getProductDetails({required int orderId}) async {
    final Map<String, dynamic> queryParams = {};
    queryParams['product_id'] = orderId;
    final response = await ref
        .read(apiClientProvider)
        .get("${AppConstants.productDetails}/",query: queryParams,);
    return response;
  }

  @override
  Future<Response> deleteProduct({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .delete("${AppConstants.deleteProduct}/$id");
    return response;
  }

  @override
  Future<Response> productInfo() async {
    return await ref.read(apiClientProvider).get(AppConstants.productInfo);
  }

  @override
  Future<Response> addProduct({required Map<String, dynamic> data}) async {
    return await ref
        .read(apiClientProvider)
        .post(AppConstants.addProduct, data: FormData.fromMap(data));
  }
}

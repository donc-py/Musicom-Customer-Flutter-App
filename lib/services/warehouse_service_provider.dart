import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/models/warehouse/add_update_warehouse.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final warehouseServiceProvider = Provider((ref) => WarehouseService(ref));

abstract class WarehouseRepository {
  Future<Response> getWarehouses(
      {required String? search, required int? perPage, required int? page});
  Future<Response> addWarehouse({required AddWarehouseModel warehouse});
  Future<Response> updateWarehouse(
      {required AddWarehouseModel warehouse, required int id});
  Future<Response> deleteWarehouse({required int id});
}

class WarehouseService implements WarehouseRepository {
  final Ref ref;
  WarehouseService(this.ref);
  @override
  Future<Response> getWarehouses({
    required String? search,
    required int? perPage,
    required int? page,
  }) async {
    final Map<String, dynamic> queryParams = {};
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;
    queryParams['search'] = search;
    if (search != null) {}
    final response = await ref.read(apiClientProvider).get(
          AppConstants.warehouses,
          query: queryParams,
        );
    return response;
  }

  @override
  Future<Response> updateWarehouse(
      {required AddWarehouseModel warehouse, required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .put("${AppConstants.updateWarehouse}/$id", data: warehouse.toMap());
    return response;
  }

  @override
  Future<Response> addWarehouse({required AddWarehouseModel warehouse}) async {
    final response = await ref.read(apiClientProvider).post(
          AppConstants.addWarehouse,
          data: warehouse.toMap(),
        );

    return response;
  }

  @override
  Future<Response> deleteWarehouse({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .delete("${AppConstants.deleteWarehouse}/$id");
    return response;
  }
}

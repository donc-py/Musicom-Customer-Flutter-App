import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/common_response.dart';
import 'package:readypos_flutter/models/warehouse/add_update_warehouse.dart';
import 'package:readypos_flutter/models/warehouse/warehouse.dart';
import 'package:readypos_flutter/services/warehouse_service_provider.dart';

final warehouseControllerProvider =
    StateNotifierProvider<WareHouseController, bool>(
        (ref) => WareHouseController(ref));

class WareHouseController extends StateNotifier<bool> {
  final Ref ref;
  WareHouseController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Warehouse>? _warehouses;
  List<Warehouse>? get warehouses => _warehouses;

  Future<void> getWarehouses({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
  }) async {
    try {
      state = true;
      final response = await ref.read(warehouseServiceProvider).getWarehouses(
            search: search,
            perPage: perPage,
            page: page,
          );
      _total = response.data['data']['total'];
      final List<dynamic> warehousesData = response.data['data']['warehouses'];
      if (pagination) {
        List<Warehouse> data = warehousesData
            .map((warehouse) => Warehouse.fromMap(warehouse))
            .toList();
        _warehouses!.addAll(data);
      } else {
        _warehouses = warehousesData
            .map((warehouse) => Warehouse.fromMap(warehouse))
            .toList();
      }
      state = false;
    } catch (e) {
      debugPrint(e.toString());
      state = false;
    }
  }

  Future<CommonResponse> addWarehouse(
      {required AddWarehouseModel warehouse}) async {
    try {
      state = true;
      final response = await ref.read(warehouseServiceProvider).addWarehouse(
            warehouse: warehouse,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(message: message, isSuccess: true);
      } else {
        state = false;
        return CommonResponse(message: message, isSuccess: false);
      }
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return CommonResponse(message: e.toString(), isSuccess: true);
    }
  }

  Future<CommonResponse> updateWarehouse(
      {required AddWarehouseModel warehouse, required int id}) async {
    try {
      state = true;
      final response = await ref.read(warehouseServiceProvider).updateWarehouse(
            warehouse: warehouse,
            id: id,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(message: message, isSuccess: true);
      } else {
        state = false;
        return CommonResponse(message: message, isSuccess: false);
      }
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return CommonResponse(message: e.toString(), isSuccess: true);
    }
  }

  Future<CommonResponse> deleteWarehouse({required int id}) async {
    try {
      final response = await ref.read(warehouseServiceProvider).deleteWarehouse(
            id: id,
          );
      final String message = response.data['message'];
      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(message: message, isSuccess: true);
      } else {
        state = false;
        return CommonResponse(message: message, isSuccess: false);
      }
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return CommonResponse(message: e.toString(), isSuccess: true);
    }
  }
}

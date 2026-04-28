import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/warehouse_model.dart';
import 'package:readypos_flutter/services/more_service_provider.dart';

final warehouseControllerProvider =
    StateNotifierProvider<WarehouseController, bool>((ref) {
  return WarehouseController(ref);
});

class WarehouseController extends StateNotifier<bool> {
  final Ref ref;
  WarehouseController(this.ref) : super(false) {
    getWarehouse();
  }

  List<WarehouseModel> _warehouseList = [];
  List<WarehouseModel> get warehouseList => _warehouseList;

  Future<void> getWarehouse() async {
    try {
      state = true;
      final response = await ref.read(moreServiceProvider).getWareHouses();
      _warehouseList = [];
      final List<dynamic> productsData = response.data['data']['warehouses'];
      if (productsData.isNotEmpty) {
        _warehouseList =
            productsData.map((e) => WarehouseModel.fromMap(e)).toList();
      }
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }
}

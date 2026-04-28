import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/models/pos_product_model.dart';
import 'package:readypos_flutter/services/pos_products_service_provider.dart';

final posProductsControllerProvider =
    StateNotifierProvider<PosProductsControler, bool>((ref) {
  return PosProductsControler(ref);
});

class PosProductsControler extends StateNotifier<bool> {
  final Ref ref;
  PosProductsControler(this.ref) : super(false);

  List<PosProductModel>? _productList;
  PosProductModel? _searchedProduct;
  List<PosProductModel>? get productList => _productList;
  PosProductModel? get searchedProduct => _searchedProduct;

  Future<void> getProducts({String? search}) async {
    int? categoryId = ref.read(productSearchType('category'))?["id"];
    int? brandId = ref.read(productSearchType('brand'))?["id"];
    print("category id: $categoryId");
    try {
      state = true;
      final response =
          await ref.read(posProductsServiceProvider).getPosProducts(
                search: search,
                categoryId: categoryId == null ? '' : categoryId.toString(),
                brandId: brandId == null ? '' : brandId.toString(),
              );
      final List<dynamic> productsData = response.data['data']['products'];
      _productList = null;
      _productList =
          productsData.map((e) => PosProductModel.fromMap(e)).toList();
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }

  Future<void> getSearchedProducts({required String barCode}) async {
    try {
      state = true;
      final response = await ref
          .read(posProductsServiceProvider)
          .getSearchedProducts(barCode: barCode);
      final List<dynamic> item = response.data['data']['products'];
      _searchedProduct = null;
      _searchedProduct =
          item.isEmpty ? null : PosProductModel.fromMap(item.first);
    } catch (e) {
      state = false;
      rethrow;
    } finally {
      state = false;
    }
  }
}

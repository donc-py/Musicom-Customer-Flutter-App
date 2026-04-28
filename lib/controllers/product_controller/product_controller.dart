import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/controllers/product_controller/product_details.dart';
import 'package:readypos_flutter/models/add_product_info_model/add_product_info_model.dart';
import 'package:readypos_flutter/models/common_response.dart';
import 'package:readypos_flutter/models/product_model.dart';
import 'package:readypos_flutter/services/product_service_provider.dart';

final productControllerProvider =
    StateNotifierProvider<ProductController, bool>(
        (ref) => ProductController(ref));

class ProductController extends StateNotifier<bool> {
  final Ref ref;
  ProductController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Product>? _products;
  List<Product>? get products => _products;

  Future<void> getProducts({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
  }) async {
    try {
      state = true;
      final response = await ref.read(productServiceProvider).getProducts(
            search: search,
            perPage: perPage,
            page: page,
          );
      _total = response.data['data']['total'];
      final List<dynamic> productsData = response.data['data']['products'];
      if (pagination) {
        List<Product> data =
            productsData.map((product) => Product.fromMap(product)).toList();
        _products!.addAll(data);
      } else {
        _products =
            productsData.map((product) => Product.fromMap(product)).toList();
      }
      state = false;
    } catch (e) {
      debugPrint(e.toString());
      state = false;
    }
  }

  Future<CommonResponse> deleteProduct({required int id}) async {
    try {
      final response = await ref.read(productServiceProvider).deleteProduct(
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

final productDetailsControllerProvider =
    StateNotifierProvider<OrderDetailsController, AsyncValue<ProductDetails>>(
        (ref) {
  final controller = OrderDetailsController(ref);
  int orderId = ref.watch(productId);
  controller.getProductDetails(orderId: orderId);
  return controller;
});

class OrderDetailsController extends StateNotifier<AsyncValue<ProductDetails>> {
  final Ref ref;
  OrderDetailsController(this.ref) : super(const AsyncLoading());

  Future<void> getProductDetails({required int orderId}) async {
    try {
      final response = await ref
          .read(productServiceProvider)
          .getProductDetails(orderId: orderId);
      final data = ProductDetails.fromMap(response.data['data']['product']);
      state = AsyncData(data);
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      state = AsyncError(e.toString(), stackTrace);
      throw stackTrace;
    }
  }
}

final addProductInfoProvider = AutoDisposeAsyncNotifierProvider<
    AddProductInfoProvider, AddProductInfoModel>(
  AddProductInfoProvider.new,
);

class AddProductInfoProvider
    extends AutoDisposeAsyncNotifier<AddProductInfoModel> {
  @override
  Future<AddProductInfoModel> build() async {
    final response = await ref.read(productServiceProvider).productInfo();
    return AddProductInfoModel.fromJson(response.data);
  }
}

class AddVarientState {
  final String? name;
  final String? code;
  final String? price;

  AddVarientState({this.name, this.code, this.price});

  AddVarientState copyWith({
    String? name,
    String? code,
    String? price,
  }) {
    return AddVarientState(
      name: name ?? this.name,
      code: code ?? this.code,
      price: price ?? this.price,
    );
  }
}

final addProductVarientControllerProvider = StateNotifierProvider.autoDispose<
    AddProductVarientController,
    List<AddVarientState>>((ref) => AddProductVarientController(ref));

class AddProductVarientController extends StateNotifier<List<AddVarientState>> {
  final Ref ref;
  AddProductVarientController(this.ref) : super([]);

  void setProductName({required String name, required String code}) {
    final data = AddVarientState(name: name, code: "$name-$code");
    state = [...state, data];
  }

  void removeProduct({required int index}) {
    state.removeAt(index);
    state = [...state];
  }

  void updatePrice({required String price, required int index}) {
    state = state
        .asMap()
        .map((key, value) {
          if (key == index) {
            return MapEntry(key, value.copyWith(price: price));
          }
          return MapEntry(key, value);
        })
        .values
        .toList();
  }

  // get all name in a list
  List<String> get allName {
    return state.map((e) => e.name!).toList();
  }

  // get all code in a list
  List<String> get allCode {
    return state.map((e) => e.code!).toList();
  }

  // get all price in a list
  List<String> get allPrice {
    return state.map((e) => e.price ?? '0').toList();
  }
}

final addProductProvider =
    NotifierProvider<AddProductController, bool>(AddProductController.new);

class AddProductController extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  Future<bool> addProduct({
    required Map<String, dynamic> data,
  }) async {
    try {
      state = true;
      var d = {
        'variant_name[0]':
            ref.read(addProductVarientControllerProvider.notifier).allName,
        'item_code[0]':
            ref.read(addProductVarientControllerProvider.notifier).allCode,
        'additional_price[0]':
            ref.read(addProductVarientControllerProvider.notifier).allPrice,
        ...data,
      };
      final response =
          await ref.read(productServiceProvider).addProduct(data: d);
      if (response.statusCode == 200) {
        state = false;
        return true;
      } else {
        state = false;
        return false;
      }
    } catch (e) {
      state = false;
      debugPrint(e.toString());
      return false;
    }
  }
}

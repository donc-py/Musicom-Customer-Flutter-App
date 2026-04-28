import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';

final cartRepo = Provider((ref) => CartRepo(ref));

class CartRepo {
  final Ref ref;
  CartRepo(this.ref);

  void incrementProductQuantity(
      {required int productId,
      required Box<HiveCartModel> box,
      required int index}) {
    final cartItem = getCartItemById(productId: productId, cartBox: box);
    if (cartItem != null) {
      cartItem.productsQTY++;
      box.putAt(index, cartItem);
    }
  }

  void decrementProductQuantity(
      {required int productId,
      required Box<HiveCartModel> cartBox,
      required int index}) {
    final cartItem = getCartItemById(productId: productId, cartBox: cartBox);
    if (cartItem != null) {
      if (cartItem.productsQTY > 1) {
        cartItem.productsQTY--;
        cartBox.putAt(index, cartItem);
      } else {
        cartBox.deleteAt(index);
      }
    }
  }

  void updateCartItemSubTotal(
      {required int productId,
      required Box<HiveCartModel> cartBox,
      required double subTotal,
      required int index}) {
    final cartItem = getCartItemById(productId: productId, cartBox: cartBox);
    if (cartItem != null) {
      cartItem.subTotal = subTotal;
      cartBox.putAt(index, cartItem);
    }
  }

  HiveCartModel? getCartItemById(
      {required int productId, required Box<HiveCartModel> cartBox}) {
    final HiveCartModel cartItem = cartBox.values.firstWhere((product) {
      return product.id == productId;
    });

    return cartItem;
  }
}

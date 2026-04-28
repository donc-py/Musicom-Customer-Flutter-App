import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';

final cartController = ChangeNotifierProvider<CartController>((ref) {
  return CartController(ref: ref);
});

class CartController extends ChangeNotifier {
  CartController({required this.ref});
  Ref ref;
  double _totalAmount = 0;
  double _subTotalAmount = 0;
  double _groupDiscountedAmount = 0;
  double? _groupDiscount;
  double? _cuponDiscount;
  double get subTotalAmount => _subTotalAmount;
  double get discountedAmount => _groupDiscountedAmount;
  double get totalAmount => _totalAmount;
  double get cuponDiscountedAmount => _cuponDiscount ?? 0;

  //getters
  void calculateSubTotal(List<HiveCartModel> cartItems) async {
    _subTotalAmount = 0;

    for (var item in cartItems) {
      _subTotalAmount += item.subTotal * item.productsQTY;
    }
    _totalAmount = _subTotalAmount;
    groupDiscount(discount: _groupDiscount);
    cuponDiscount(discount: _cuponDiscount);
    await Future.delayed(Duration.zero);
    notifyListeners();
  }

  // setters
  void setGroupDiscount(double? discount) async {
    _groupDiscount = discount;
    groupDiscount(discount: _groupDiscount);
    await Future.delayed(Duration.zero);
    notifyListeners();
  }

  void setCuponDiscount(double? discount) async {
    _cuponDiscount = discount;
    cuponDiscount(discount: _cuponDiscount);
    await Future.delayed(Duration.zero);
    notifyListeners();
  }

  // others
  void groupDiscount({double? discount}) async {
    if (discount == null) {
      return;
    }
    _groupDiscountedAmount = _subTotalAmount * (discount / 100);
    _subTotalAmount -= _groupDiscountedAmount;
    await Future.delayed(Duration.zero);
    notifyListeners();
  }

  void cuponDiscount({double? discount}) async {
    if (discount == null) {
      return;
    }
    if (_subTotalAmount == 0) {
      _cuponDiscount = null;
      // notifyListeners();
      return;
    }
    _subTotalAmount -= discount;
    await Future.delayed(Duration.zero);
    notifyListeners();
  }

  void clearFiles() {
    _totalAmount = 0;
    _subTotalAmount = 0;
    _groupDiscount = null;
    _groupDiscountedAmount = 0;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/enums.dart';
import 'package:readypos_flutter/models/customers_model/customer_model.dart';
import 'package:rive/rive.dart';

final selectedPaymentMethodProvider = StateProvider<PaymentMethod>((ref) {
  return PaymentMethod.cash;
});

final selectedCustomerProvider = StateProvider<CustomerModel?>((ref) {
  return null;
});

final searchCustomerTextController = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

final cuponTextEditingController = Provider<TextEditingController>((ref) {
  return TextEditingController();
});

final riveAnimationControllerProvider = Provider<Artboard?>((ref) {
  return null;
});

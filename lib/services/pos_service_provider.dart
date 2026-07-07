import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final posServiceProvider = Provider((ref) {
  return POSService(ref);
});

abstract class POSRepository {
  Future<Response> store({required Map<String, dynamic> data});
  Future<Response> getDrafts();
  Future<Response> paymentSuccess({required int id});
  Future<Response> deleteDraft({required int id});
  Future<Response> createPaypalOrder({required int orderId});       // 👈 orderId
  Future<Response> capturePaypalPayment({
    required String token,
    required int orderId,                                           // 👈 orderId
  });
}

class POSService implements POSRepository {
  final Ref ref;
  const POSService(this.ref);

  @override
  Future<Response> createPaypalOrder({required int orderId}) {     // 👈 orderId
    return ref.read(apiClientProvider).post(
      AppConstants.paypalCreateOrder,
      data: {'order_id': orderId},                                  // 👈 orderId
    );
  }

  @override
  Future<Response> capturePaypalPayment({
    required String token,
    required int orderId,                                           // 👈 orderId
  }) {
    return ref.read(apiClientProvider).post(
      AppConstants.paypalCapture,
      data: {
        'token': token,
        'order_id': orderId,
      },
    );
  }

  @override
  Future<Response> store({required Map<String, dynamic> data}) {
    return ref.read(apiClientProvider).post(
      AppConstants.posStore,
      data: data,
    );
  }

  @override
  Future<Response> getDrafts() {
    return ref.read(apiClientProvider).get(AppConstants.drafts);
  }

  @override
  Future<Response> paymentSuccess({required int id}) {
    return ref
        .read(apiClientProvider)
        .get("${AppConstants.paymentSuccess}/$id");
  }

  @override
  Future<Response> deleteDraft({required int id}) {
    return ref
        .read(apiClientProvider)
        .get("${AppConstants.deleteDraft}/$id");
  }
}
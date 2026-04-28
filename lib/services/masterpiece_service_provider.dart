import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final masterpieceServiceProvider = Provider((ref) => MasterpieceService(ref));

abstract class MasterpieceRepository {
  Future<Response> getMasterpieces({
    required String? search,
    required int? perPage,
    required int? page,
    int? collectionId,
    int? brandId,
  });
}

class MasterpieceService implements MasterpieceRepository {
  final Ref ref;
  MasterpieceService(this.ref);

  @override
  Future<Response> getMasterpieces({
    required String? search,
    required int? perPage,
    required int? page,
    int? collectionId,
    int? brandId,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null) queryParams['search'] = search;
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;
    if (collectionId != null) queryParams['collection_id'] = collectionId;
    if (brandId != null) queryParams['brand_id'] = brandId;

    final response = await ref.read(apiClientProvider).get(
          AppConstants.masterpieces,
          query: queryParams,
        );
    return response;
  }
}

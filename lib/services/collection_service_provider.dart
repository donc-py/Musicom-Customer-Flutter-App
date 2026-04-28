import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final collectionServiceProvider = Provider((ref) => CollectionService(ref));

abstract class CollectionRepository {
  Future<Response> getCollections(
      {required String? search, required int? perPage, required int? page});
  Future<Response> addCollection(
      {required String collectionName, required File? collectionImage});
  Future<Response> updateCollection(
      {required int collectionId,
      required String collectionName,
      required File? collectionImage});
  Future<Response> deleteCollection({required int id});
}

class CollectionService implements CollectionRepository {
  final Ref ref;
  CollectionService(this.ref);
  @override
  Future<Response> getCollections({
    required String? search,
    required int? perPage,
    required int? page,
  }) async {
    final Map<String, dynamic> queryParams = {};
    if (search != null) queryParams['search'] = search;
    queryParams['page'] = page;
    queryParams['per_page'] = perPage;

    if (search != null) {}
    final response = await ref.read(apiClientProvider).get(
          AppConstants.collections,
          query: queryParams,
        );
    return response;
  }

  @override
  Future<Response> addCollection(
      {required String collectionName, required File? collectionImage}) async {
    final response = await ref.read(apiClientProvider).post(
          AppConstants.addCollection,
          data: FormData.fromMap(
            {
              'title': collectionName,
              'image': collectionImage != null
                  ? await MultipartFile.fromFile(
                      collectionImage.path,
                      filename: 'brand_image.jpg',
                    )
                  : null
            },
          ),
        );

    return response;
  }

  @override
  Future<Response> updateCollection(
      {required int collectionId,
      required String collectionName,
      required File? collectionImage}) async {
    final response = await ref.read(apiClientProvider).post(
          "${AppConstants.updateCollection}/$collectionId",
          data: FormData.fromMap(
            {
              'title': collectionName,
              'image': collectionImage != null
                  ? await MultipartFile.fromFile(
                      collectionImage.path,
                      filename: 'brand_image.jpg',
                    )
                  : null
            },
          ),
        );

    return response;
  }

  @override
  Future<Response> deleteCollection({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .delete("${AppConstants.deleteCollection}/$id");
    return response;
  }
}

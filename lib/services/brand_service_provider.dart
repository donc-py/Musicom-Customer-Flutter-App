import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/utils/api_client.dart';

final brandServiceProvider = Provider((ref) => BrandService(ref));

abstract class BrandRepository {
  Future<Response> getBrands(
      {required String? search, required int? perPage, required int? page});
  Future<Response> addBrand(
      {required String brandName, required File? brandImage});
  Future<Response> updateBrand(
      {required int brandId,
      required String brandName,
      required File? brandImage});
  Future<Response> deleteBrand({required int id});
}

class BrandService implements BrandRepository {
  final Ref ref;
  BrandService(this.ref);
  @override
  Future<Response> getBrands({
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
          AppConstants.brands,
          query: queryParams,
        );
    return response;
  }

  @override
  Future<Response> addBrand(
      {required String brandName, required File? brandImage}) async {
    final response = await ref.read(apiClientProvider).post(
          AppConstants.addBrand,
          data: FormData.fromMap(
            {
              'title': brandName,
              'image': brandImage != null
                  ? await MultipartFile.fromFile(
                      brandImage.path,
                      filename: 'brand_image.jpg',
                    )
                  : null
            },
          ),
        );

    return response;
  }

  @override
  Future<Response> updateBrand(
      {required int brandId,
      required String brandName,
      required File? brandImage}) async {
    final response = await ref.read(apiClientProvider).post(
          "${AppConstants.updateBrand}/$brandId",
          data: FormData.fromMap(
            {
              'title': brandName,
              'image': brandImage != null
                  ? await MultipartFile.fromFile(
                      brandImage.path,
                      filename: 'brand_image.jpg',
                    )
                  : null
            },
          ),
        );

    return response;
  }

  @override
  Future<Response> deleteBrand({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .delete("${AppConstants.deleteBrand}/$id");
    return response;
  }
}

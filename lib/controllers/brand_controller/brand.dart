import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/models/common_response.dart';
import 'package:readypos_flutter/services/brand_service_provider.dart';

final brandControllerProvider =
    StateNotifierProvider<BrandController, bool>((ref) => BrandController(ref));

class BrandController extends StateNotifier<bool> {
  final Ref ref;
  BrandController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Brand>? _brands;
  List<Brand>? get brands => _brands;

  // Future<void> getBrands({
  //   required int page,
  //   required int perPage,
  //   required String? search,
  //   required bool pagination,
  // }) async {
  //   try {
  //     state = true;
  //     final response = await ref.read(brandServiceProvider).getBrands(
  //           search: search,
  //           perPage: perPage,
  //           page: page,
  //         );
  //     _total = response.data['data']['total'];
  //     final List<dynamic> brandsData = response.data['data']['brands'];
  //     if (pagination) {
  //       List<Brand> data =
  //           brandsData.map((category) => Brand.fromMap(category)).toList();
  //       _brands!.addAll(data);
  //     } else {
  //       _brands =
  //           brandsData.map((category) => Brand.fromMap(category)).toList();
  //     }
  //     state = false;
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     state = false;
  //   }
  // }

  Future<void> getBrands({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
  }) async {
    try {
      state = true;
      final response = await ref.read(brandServiceProvider).getBrands(
            search: search,
            perPage: perPage,
            page: page,
          );
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];
        _total = data['total'] as int?;
        
        if (data['brands'] != null) {
          final List<dynamic> categoriesData = data['brands'] as List<dynamic>;
          
          if (pagination && _brands != null) {
            final newCategories = categoriesData
                .map((category) => Brand.fromMap(category as Map<String, dynamic>))
                .toList();
            _brands!.addAll(newCategories);
          } else {
            _brands = categoriesData
                .map((category) => Brand.fromMap(category as Map<String, dynamic>))
                .toList();
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error fetching categories: ${e.toString()}');
      debugPrint('Stack trace: $stackTrace');
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> addBrand(
      {required String brandName, required File? brandImage}) async {
    try {
      state = true;
      final response = await ref.read(brandServiceProvider).addBrand(
            brandName: brandName,
            brandImage: brandImage,
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

  Future<CommonResponse> updateBrand(
      {required int brandId,
      required String brandName,
      required File? brandImage}) async {
    try {
      state = true;
      final response = await ref.read(brandServiceProvider).updateBrand(
            brandId: brandId,
            brandName: brandName,
            brandImage: brandImage,
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

  Future<CommonResponse> deleteBrand({required int id}) async {
    try {
      final response = await ref.read(brandServiceProvider).deleteBrand(
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

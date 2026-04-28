import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readypos_flutter/models/collection/collection.dart';
import 'package:readypos_flutter/models/common_response.dart';
import 'package:readypos_flutter/services/collection_service_provider.dart';

final collectionControllerProvider =
    StateNotifierProvider<CollectionController, bool>((ref) => CollectionController(ref));

class CollectionController extends StateNotifier<bool> {
  final Ref ref;
  CollectionController(this.ref) : super(false);

  int? _total;
  int? get total => _total;

  List<Collection>? _collections;
  List<Collection>? get collections => _collections;

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

  Future<void> getCollections({
    required int page,
    required int perPage,
    required String? search,
    required bool pagination,
  }) async {
    try {
      state = true;
      final response = await ref.read(collectionServiceProvider).getCollections(
            search: search,
            perPage: perPage,
            page: page,
          );
      
      if (response.statusCode == 200 && response.data['data'] != null) {
        final data = response.data['data'];
        _total = data['total'] as int?;
        
        if (data['collections'] != null) {
          final List<dynamic> categoriesData = data['collections'] as List<dynamic>;
          
          if (pagination && _collections != null) {
            final newCategories = categoriesData
                .map((category) => Collection.fromMap(category as Map<String, dynamic>))
                .toList();
            _collections!.addAll(newCategories);
          } else {
            _collections = categoriesData
                .map((category) => Collection.fromMap(category as Map<String, dynamic>))
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

  Future<CommonResponse> addCollection(
      {required String collectionName, required File? collectionImage}) async {
    try {
      state = true;
      final response = await ref.read(collectionServiceProvider).addCollection(
            collectionName: collectionName,
            collectionImage: collectionImage,
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

  Future<CommonResponse> updateCollection(
      {required int collectionId,
      required String collectionName,
      required File? collectionImage}) async {
    try {
      state = true;
      final response = await ref.read(collectionServiceProvider).updateCollection(
            collectionId: collectionId,
            collectionName: collectionName,
            collectionImage: collectionImage,
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

  Future<CommonResponse> deleteCollection({required int id}) async {
    try {
      final response = await ref.read(collectionServiceProvider).deleteCollection(
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

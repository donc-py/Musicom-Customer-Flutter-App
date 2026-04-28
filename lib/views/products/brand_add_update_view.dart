// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:readypos_flutter/models/brand/brand_update.dart';
import 'package:readypos_flutter/views/products/layouts/brand_Add_update_layout.dart';

class BrandAddUpdateView extends StatelessWidget {
  final UpdateBrandModel? updateBrandModel;
  const BrandAddUpdateView({
    super.key,
    required this.updateBrandModel,
  });

  @override
  Widget build(BuildContext context) {
    return BrandAddUpdateLayout(
      updateBrandModel: updateBrandModel,
    );
  }
}

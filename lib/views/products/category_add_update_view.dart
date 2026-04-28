// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:readypos_flutter/views/products/layouts/category_add_update_layout.dart';

class CategoryAddUpdateView extends StatelessWidget {
  final CategoryAddUpdateArguament? categoryAddUpdateArguament;
  const CategoryAddUpdateView({
    super.key,
    this.categoryAddUpdateArguament,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryAddUpdateLayout(
      categoryAddUpdateArguament: categoryAddUpdateArguament,
    );
  }
}

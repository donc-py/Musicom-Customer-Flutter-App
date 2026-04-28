// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:readypos_flutter/models/warehouse/warehouse.dart';
import 'package:readypos_flutter/views/products/layouts/warehouse_add_update_layout.dart';

class WarehouseAddUpdateView extends StatelessWidget {
  final Warehouse? warehouse;
  const WarehouseAddUpdateView({
    super.key,
    this.warehouse,
  });

  @override
  Widget build(BuildContext context) {
    return WarehouseAddUpdateLayout(
      warehouse: warehouse,
    );
  }
}

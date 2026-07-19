import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/models/product_model.dart';

class ProductDetailSheet extends ConsumerStatefulWidget {
  final Product product;
  const ProductDetailSheet({super.key, required this.product});

  static void show(BuildContext context, {required Product product}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => ProductDetailSheet(product: product),
    );
  }

  @override
  ConsumerState<ProductDetailSheet> createState() =>
      _ProductDetailSheetState();
}

class _ProductDetailSheetState extends ConsumerState<ProductDetailSheet> {
  int _qty = 1;
  dynamic _cartKey; // key en Hive si ya está en carrito

  Box<HiveCartModel> get _box =>
      Hive.box<HiveCartModel>(AppConstants.cartBox);

  @override
  void initState() {
    super.initState();
    // ── leer qty real del carrito al abrir ──────────────────────
    final key = _box.keys.firstWhere(
      (k) => _box.get(k)?.id == widget.product.id,
      orElse: () => null,
    );
    if (key != null) {
      _cartKey = key;
      _qty = _box.get(key)!.productsQTY;
    }
  }

  bool get _inCart => _cartKey != null;
  double get _price => widget.product.price ?? 0.0;
  double get _total => _price * _qty;

  // ── actualiza qty en Hive si ya está en carrito ──────────────
  Future<void> _updateCartQty(int newQty) async {
    if (!_inCart) {
      setState(() => _qty = newQty);
      return;
    }
    final old = _box.get(_cartKey)!;
    await _box.put(
      _cartKey,
      HiveCartModel(
        id: old.id,
        name: old.name,
        code: old.code,
        thumbnail: old.thumbnail,
        subTotal: _price * newQty,
        productsQTY: newQty,
      ),
    );
    setState(() => _qty = newQty);
  }

  // ── navega al tab Carrello ────────────────────────────────────
  void _goToCart() {
    Navigator.pop(context);
    ref.read(selectedIndexProvider.notifier).state = 3;
    ref.read(bottomTabControllerProvider).jumpToPage(3);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── handle ───────────────────────────────────────────
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            // ── imagen ───────────────────────────────────────────
            if (p.thumbnail != null && p.thumbnail!.isNotEmpty)
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.r)),
                child: CachedNetworkImage(
                  imageUrl: p.thumbnail!,
                  width: double.infinity,
                  height: 220.h,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: 220.h,
                    color: Colors.grey[100],
                    child: Icon(Icons.image,
                        color: Colors.grey[300], size: 48.r),
                  ),
                ),
              )
            else
              Container(
                height: 120.h,
                color: Colors.grey[100],
                child: Center(
                    child: Icon(Icons.image,
                        color: Colors.grey[300], size: 48.r)),
              ),

            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── nombre + precio ──────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(p.name ?? '',
                            style: AppTextStyle.title
                                .copyWith(fontSize: 20.sp)),
                      ),
                      Gap(12.w),
                      Text(
                        '${_price.toStringAsFixed(2)} €',
                        style: AppTextStyle.title.copyWith(
                            fontSize: 20.sp,
                            color: AppColor.primaryColor),
                      ),
                    ],
                  ),

                  if (p.brand != null) ...[
                    Gap(4.h),
                    Text(p.brand!,
                        style: AppTextStyle.normalBody
                            .copyWith(color: Colors.grey)),
                  ],

                  Gap(16.h),
                  Divider(color: Colors.grey[200]),
                  Gap(12.h),

                  if (p.code != null && p.code!.isNotEmpty)
                    _detailRow('Codice', p.code!),
                  if (p.category != null && p.category!.isNotEmpty)
                    _detailRow('Categoria', p.category!),

                  Gap(20.h),

                  // ── selector cantidad ────────────────────────
                  Row(
                    children: [
                      Text('Quantità',
                          style: AppTextStyle.normalBody
                              .copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      _qtyButton(
                        icon: Icons.remove,
                        active: _qty > 1,
                        onTap: _qty > 1
                            ? () => _updateCartQty(_qty - 1)
                            : null,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text('$_qty',
                            style: AppTextStyle.title
                                .copyWith(fontSize: 18.sp)),
                      ),
                      _qtyButton(
                        icon: Icons.add,
                        active: true,
                        onTap: () => _updateCartQty(_qty + 1),
                      ),
                    ],
                  ),

                  Gap(12.h),

                  // ── total ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Totale',
                          style: AppTextStyle.normalBody
                              .copyWith(color: Colors.grey)),
                      Text('${_total.toStringAsFixed(2)} €',
                          style: AppTextStyle.title.copyWith(
                              fontSize: 18.sp,
                              color: AppColor.primaryColor)),
                    ],
                  ),

                  Gap(20.h),

                  // ── botón principal ──────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: _inCart
                          ? _goToCart
                          : () async {
                              final key = await _box.add(HiveCartModel(
                                id: p.id,
                                name: p.name ?? 'Prodotto',
                                code: p.code ?? '',
                                thumbnail: p.thumbnail ?? '',
                                subTotal: _total,
                                productsQTY: _qty,
                              ));
                              setState(() => _cartKey = key);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _inCart
                            ? Colors.green
                            : AppColor.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        _inCart
                            ? 'Vai al carrello'
                            : 'Aggiungi al carrello  •  ${_total.toStringAsFixed(2)} €',
                        style: AppTextStyle.normalBody.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),

                  Gap(12.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) => Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Row(
          children: [
            SizedBox(
              width: 90.w,
              child: Text(label,
                  style: AppTextStyle.smallBody
                      .copyWith(color: Colors.grey)),
            ),
            Expanded(
              child: Text(value,
                  style: AppTextStyle.normalBody
                      .copyWith(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );

  Widget _qtyButton({
    required IconData icon,
    required bool active,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: active ? AppColor.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon,
            size: 18.r,
            color: active ? Colors.white : Colors.grey[400]),
      ),
    );
  }
}
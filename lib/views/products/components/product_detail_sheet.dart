import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/models/product_model.dart';

/// Llama con:
/// ```dart
/// ProductDetailSheet.show(context, product: product);
/// ```
class ProductDetailSheet extends StatefulWidget {
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
  State<ProductDetailSheet> createState() => _ProductDetailSheetState();
}

class _ProductDetailSheetState extends State<ProductDetailSheet> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final price = p.price ?? 0.0;
    final total = price * _qty;

    return Padding(
      // sube el sheet sobre el teclado si aparece
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── handle ────────────────────────────────────────────────────
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

            // ── imagen ────────────────────────────────────────────────────
            if (p.thumbnail != null && p.thumbnail!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: CachedNetworkImage(
                  imageUrl: p.thumbnail!,
                  width: double.infinity,
                  height: 220.h,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) => Container(
                    height: 220.h,
                    color: Colors.grey[100],
                    child:
                        Icon(Icons.image, color: Colors.grey[300], size: 48.r),
                  ),
                ),
              )
            else
              Container(
                height: 120.h,
                color: Colors.grey[100],
                child: Center(
                    child:
                        Icon(Icons.image, color: Colors.grey[300], size: 48.r)),
              ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── nombre + precio ──────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(p.name ?? '',
                            style:
                                AppTextStyle.title.copyWith(fontSize: 20.sp)),
                      ),
                      Gap(12.w),
                      Text(
                        '${price.toStringAsFixed(2)} €',
                        style: AppTextStyle.title.copyWith(
                            fontSize: 20.sp, color: AppColor.primaryColor),
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

                  // ── detalles ─────────────────────────────────────────────
                  if (p.code != null && p.code!.isNotEmpty)
                    _detailRow('Codice', p.code!),
                  if (p.category != null && p.category!.isNotEmpty)
                    _detailRow('Categoria', p.category!),

                  Gap(20.h),

                  // ── selector de cantidad ─────────────────────────────────
                  Row(
                    children: [
                      Text('Quantità',
                          style: AppTextStyle.normalBody
                              .copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      _qtyButton(
                        icon: Icons.remove,
                        active: _qty > 1,
                        onTap: () {
                          if (_qty > 1) setState(() => _qty--);
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text('$_qty',
                            style:
                                AppTextStyle.title.copyWith(fontSize: 18.sp)),
                      ),
                      _qtyButton(
                        icon: Icons.add,
                        active: true,
                        onTap: () => setState(() => _qty++),
                      ),
                    ],
                  ),

                  Gap(12.h),

                  // ── total ────────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Totale',
                          style: AppTextStyle.normalBody
                              .copyWith(color: Colors.grey)),
                      Text('${total.toStringAsFixed(2)} €',
                          style: AppTextStyle.title.copyWith(
                              fontSize: 18.sp, color: AppColor.primaryColor)),
                    ],
                  ),

                  Gap(20.h),

                  // ── botón aggiungi al carrello (FIX BUG-014) ─────────────
                  ValueListenableBuilder<Box<HiveCartModel>>(
                    valueListenable:
                        Hive.box<HiveCartModel>(AppConstants.cartBox)
                            .listenable(),
                    builder: (context, box, _) {
                      final inCart = box.values.any((e) => e.id == p.id);
                      return SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: inCart
                              ? null
                              : () async {
                                  await box.add(HiveCartModel(
                                    id: p.id,
                                    name: p.name ?? 'Prodotto',
                                    code: p.code ?? '',
                                    thumbnail: p.thumbnail ?? '',
                                    subTotal: price * _qty,
                                    productsQTY: _qty,
                                  ));
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      content: Text(
                                          '${p.name} aggiunto al carrello'),
                                      backgroundColor: Colors.green,
                                    ));
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                inCart ? Colors.grey : AppColor.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            inCart
                                ? 'Già nel carrello'
                                : 'Aggiungi al carrello  •  ${total.toStringAsFixed(2)} €',
                            style: AppTextStyle.normalBody.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    },
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
                  style: AppTextStyle.smallBody.copyWith(color: Colors.grey)),
            ),
            Expanded(
              child: Text(value,
                  style: AppTextStyle.normalBody
                      .copyWith(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );

  Widget _qtyButton(
      {required IconData icon,
      required bool active,
      required VoidCallback onTap}) {
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
            size: 18.r, color: active ? Colors.white : Colors.grey[400]),
      ),
    );
  }
}

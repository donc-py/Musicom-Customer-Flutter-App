import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/app_currency_provider.dart';
import 'package:readypos_flutter/controllers/pos_controller.dart/pos_controller.dart';

class PosOrdersScreen extends ConsumerStatefulWidget {
  const PosOrdersScreen({super.key});

  @override
  ConsumerState<PosOrdersScreen> createState() => _PosOrdersScreenState();
}

class _PosOrdersScreenState extends ConsumerState<PosOrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        ref.read(posOrdersControllerProvider.notifier).getOrders());
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(posOrdersControllerProvider);
    final orders = ref.watch(posOrdersControllerProvider.notifier).orders;
    final currency = ref.watch(appcurrencyNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Storia degli acquisti'),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (orders == null || orders.isEmpty)
              ? const Center(child: Text('Nessun ordine ancora'))
              : ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColor.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.05),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.r),
                                topRight: Radius.circular(12.r),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '#${order.orderCode}',
                                    style: AppTextStyle.largeBody.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                _statusChip(order.paymentStatus),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.createdAt,
                                  style: AppTextStyle.smallBody.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                                Gap(10.h),

                                // Productos
                                ...order.products.map((p) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6.r),
                                        child: CachedNetworkImage(
                                          imageUrl: p.thumbnail,
                                          width: 40.w,
                                          height: 40.w,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              Container(
                                            width: 40.w,
                                            height: 40.w,
                                            color: AppColor.borderColor,
                                            child: const Icon(Icons.image,
                                                size: 20),
                                          ),
                                        ),
                                      ),
                                      Gap(10.w),
                                      Expanded(
                                        child: Text(
                                          p.name,
                                          style: AppTextStyle.normalBody,
                                        ),
                                      ),
                                      Text(
                                        'x${p.quantity}',
                                        style: AppTextStyle.normalBody.copyWith(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Gap(8.w),
                                      Text(
                                        currency.currencyValue(
                                            p.price * p.quantity),
                                        style: AppTextStyle.normalBody.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: AppColor.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Total',
                                        style: AppTextStyle.normalBody.copyWith(
                                            fontWeight: FontWeight.w700)),
                                    Text(
                                      currency.currencyValue(order.payableAmount),
                                      style: AppTextStyle.normalBody.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColor.primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _statusChip(String status) {
    final isPaid = status.toLowerCase().contains('paid');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isPaid
            ? Colors.green.withOpacity(0.1)
            : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        isPaid ? 'Pagato' : 'in attesa di pagamento',
        style: AppTextStyle.smallBody.copyWith(
          color: isPaid ? Colors.green : Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
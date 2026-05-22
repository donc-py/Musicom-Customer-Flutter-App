import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/product_controller/product_controller.dart';
import 'package:readypos_flutter/views/museum/global_search_delegate.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/collection_controller/collection.dart';
import 'package:readypos_flutter/models/cart_models/hive_cart_model.dart';
import 'package:readypos_flutter/models/product_model.dart';
import 'package:readypos_flutter/views/dashboard/components/logo_section.dart';
import 'package:readypos_flutter/views/core/components/app_drawer.dart';

class ExploreLayout extends ConsumerStatefulWidget {
  const ExploreLayout({super.key});

  @override
  ConsumerState<ExploreLayout> createState() => _ExploreLayoutState();
}

class _ExploreLayoutState extends ConsumerState<ExploreLayout> {
  int? _expandedTicketIndex;
  final Map<int, int> _quantities = {};

  static const List<Map<String, String>> _orari = [
    {
      'label': 'Apertura',
      'days': 'Da Lunedì a Venerdì',
      'hours': '09:00 – 13:00\n16:00 – 19:00',
    },
    {
      'label': 'Apertura',
      'days': 'Sabato e Domenica',
      'hours': '09:00 – 19:00\nOrario continuato',
    },
  ];

  // ─── helpers ─────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(title,
            style: AppTextStyle.title
                .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
      );

  // ─── quick access ────────────────────────────────────────────────────────

  Widget _quickAccess() {
    final items = [
      {
        'icon': Icons.airplane_ticket_outlined,
        'label': 'Biglietti',
        'sub': 'Prezzi, sconti'
      },
      {'icon': Icons.access_time_outlined, 'label': 'Orari', 'sub': 'Apertura'},
      {
        'icon': Icons.location_on_outlined,
        'label': 'Posizione',
        'sub': 'Localizzazione'
      },
    ];
    return Row(
      children: items.map((item) {
        final idx = items.indexOf(item);
        return Expanded(
          child: GestureDetector(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(right: idx < 2 ? 8.w : 0),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(item['icon'] as IconData,
                      size: 22.r, color: AppColor.primaryColor),
                  Gap(8.h),
                  Text(item['label'] as String,
                      style: AppTextStyle.normalBody
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text(item['sub'] as String,
                      style:
                          AppTextStyle.smallBody.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── biglietti ───────────────────────────────────────────────────────────

  // FIX: recibe Product completo para poder agregarlo al carrito
  Widget _buildTicketRow(Product ticket, int index) {
    final isExpanded = _expandedTicketIndex == index;
    final qty = _quantities[index] ?? 1;
    final price = ticket.price ?? 0.0;
    final total = price * qty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color:
            isExpanded ? AppColor.primaryColor.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isExpanded
              ? AppColor.primaryColor.withOpacity(0.3)
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          // header row
          InkWell(
            borderRadius: BorderRadius.circular(10.r),
            onTap: () => setState(() {
              _expandedTicketIndex = isExpanded ? null : index;
              if (!_quantities.containsKey(index)) _quantities[index] = 1;
            }),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ticket.name ?? '',
                            style: AppTextStyle.normalBody
                                .copyWith(fontWeight: FontWeight.w600)),
                        if (ticket.brand != null)
                          Text(ticket.brand!,
                              style: AppTextStyle.smallBody.copyWith(
                                  color: Colors.grey, fontSize: 11.sp)),
                      ],
                    ),
                  ),
                  Text('${price.toStringAsFixed(2)} €',
                      style: AppTextStyle.normalBody.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: 14.sp)),
                ],
              ),
            ),
          ),
          // expanded: quantity + checkout
          if (isExpanded)
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
              child: Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Quantità',
                            style: AppTextStyle.smallBody
                                .copyWith(color: Colors.grey)),
                        const Spacer(),
                        _qtyButton(
                          icon: Icons.remove,
                          onTap: qty > 1
                              ? () =>
                                  setState(() => _quantities[index] = qty - 1)
                              : null,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text('$qty',
                              style: AppTextStyle.normalBody
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ),
                        _qtyButton(
                          icon: Icons.add,
                          onTap: () =>
                              setState(() => _quantities[index] = qty + 1),
                        ),
                      ],
                    ),
                    Divider(height: 16.h, color: Colors.grey[200]),
                    Row(
                      children: [
                        Text('Totale',
                            style: AppTextStyle.smallBody
                                .copyWith(color: Colors.grey)),
                        Gap(8.w),
                        Text('${total.toStringAsFixed(2)} €',
                            style: AppTextStyle.normalBody
                                .copyWith(fontWeight: FontWeight.w700)),
                        const Spacer(),
                        // FIX: botón checkout agrega al carrito Hive
                        ValueListenableBuilder<Box<HiveCartModel>>(
                          valueListenable:
                              Hive.box<HiveCartModel>(AppConstants.cartBox)
                                  .listenable(),
                          builder: (context, box, _) {
                            final inCart =
                                box.values.any((e) => e.id == ticket.id);
                            return SizedBox(
                              height: 36.h,
                              child: ElevatedButton(
                                onPressed: inCart
                                    ? null
                                    : () async {
                                        final cartModel = HiveCartModel(
                                          id: ticket.id,
                                          name: ticket.name ?? 'Biglietto',
                                          code: ticket.code ?? '',
                                          thumbnail: ticket.thumbnail ?? '',
                                          subTotal: price * qty,
                                          productsQTY: qty,
                                        );
                                        await box.add(cartModel);
                                        // cerrar el accordion tras añadir
                                        setState(
                                            () => _expandedTicketIndex = null);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          content: Text(
                                              '${ticket.name} aggiunto al carrello'),
                                          backgroundColor: Colors.green,
                                        ));
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: inCart
                                      ? Colors.grey
                                      : AppColor.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                ),
                                child:
                                    Text(inCart ? 'Nel carrello' : 'Checkout'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _qtyButton({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28.w,
        height: 28.w,
        decoration: BoxDecoration(
          color: onTap != null ? AppColor.primaryColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Icon(icon,
            size: 16.r, color: onTap != null ? Colors.white : Colors.grey),
      ),
    );
  }

  // ─── orari ───────────────────────────────────────────────────────────────

  Widget _buildOrariSection() {
    return Column(
      children: _orari.map((o) {
        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(o['label']!,
                        style: AppTextStyle.normalBody
                            .copyWith(fontWeight: FontWeight.w600)),
                    Gap(2.h),
                    Text(o['days']!,
                        style: AppTextStyle.smallBody
                            .copyWith(color: Colors.grey)),
                  ],
                ),
              ),
              Text(o['hours']!,
                  textAlign: TextAlign.right,
                  style: AppTextStyle.smallBody.copyWith(
                      decoration: TextDecoration.underline, fontSize: 13.sp)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── posizione ───────────────────────────────────────────────────────────

  Widget _buildPosizioneSection() {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.map_outlined, size: 32.r, color: Colors.grey[600]),
          Gap(12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Villa delle Favare',
                  style: AppTextStyle.normalBody.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500)),
              Text('Via Vittorio Emanuele, Biancavilla (CT)',
                  style: AppTextStyle.smallBody.copyWith(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── BUILD ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Container(
            color: AdaptiveTheme.of(context).mode.isDark
                ? AppColor.darkBackgroundColor
                : AppColor.whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Gap(68.h), const LogoSection()],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3)
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: GestureDetector(
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.r)),
                          ),
                          builder: (_) => const GlobalSearchSheet(),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            Gap(8.w),
                            Text('Cerca (opere, autori)...',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.grey[400])),
                          ],
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.filter_list), onPressed: () {}),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Esplora il MUCICOM',
                      style: AppTextStyle.title.copyWith(
                          fontSize: 22.sp, fontWeight: FontWeight.w700)),
                  Gap(12.h),
                  _quickAccess(),
                  Gap(24.h),

                  // ── Biglietti ────────────────────────────────────────
                  _sectionTitle('Biglietti'),
                  Consumer(builder: (context, ref, _) {
                    final isLoading = ref.watch(productControllerProvider);
                    final products =
                        ref.watch(productControllerProvider.notifier).products;
                    // FIX: filtrar por nombre "biglietto" (case-insensitive)
                    final tickets = (products ?? [])
                        .where((p) =>
                            p.name?.toLowerCase().contains('biglietto') == true)
                        .toList();

                    if (isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (tickets.isEmpty) {
                      return Center(
                          child: Text('Nessun biglietto disponibile',
                              style: AppTextStyle.smallBody
                                  .copyWith(color: Colors.grey)));
                    }
                    // FIX: pasar Product completo, no .toMap()
                    return Column(
                      children: List.generate(
                        tickets.length,
                        (i) => _buildTicketRow(tickets[i], i),
                      ),
                    );
                  }),

                  Gap(8.h),
                  _sectionTitle('Orari'),
                  _buildOrariSection(),
                  Gap(8.h),
                  _sectionTitle('Posizione'),
                  _buildPosizioneSection(),
                  Gap(32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

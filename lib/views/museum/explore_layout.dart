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
import 'package:readypos_flutter/controllers/misc/misc_provider.dart';


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

  // FIX: keys para poder hacer scroll a cada sección
  final _bigliettiKey = GlobalKey();
  final _orariKey = GlobalKey();
  final _posizioneKey = GlobalKey();

   @override
  void initState() {
    super.initState();
    // FIX: si venimos del Dashboard con una sección pendiente, saltar ahí
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPendingSection();
    });
  }

  void _checkPendingSection() {
    final pending = ref.read(pendingExploreSectionProvider);
    if (pending != null) {
      _scrollToSection(pending);
      // limpiar para que no se repita si vuelves a esta pantalla sin pedirlo
      ref.read(pendingExploreSectionProvider.notifier).state = null;
    }
  }

  void _scrollToSection(ExploreSection section) {
    final key = switch (section) {
      ExploreSection.biglietti => _bigliettiKey,
      ExploreSection.orari => _orariKey,
      ExploreSection.posizione => _posizioneKey,
    };
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
  }

  // ─── helpers ─────────────────────────────────────────────────────────────

  Widget _sectionTitle(String title, {Key? key}) => Padding(
        key: key,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(title,
            style: AppTextStyle.title
                .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
      );

  // ─── quick access ────────────────────────────────────────────────────────

  Widget _quickAccess() {
  final items = [
    {'icon': Icons.airplane_ticket_outlined, 'label': 'Biglietti', 'sub': 'Prezzi, sconti', 'section': ExploreSection.biglietti},
    {'icon': Icons.access_time_outlined, 'label': 'Orari', 'sub': 'Apertura', 'section': ExploreSection.orari},
    {'icon': Icons.location_on_outlined, 'label': 'Posizione', 'sub': 'Localizzazione', 'section': ExploreSection.posizione},
  ];
  return Row(
    children: items.map((item) {
      final idx = items.indexOf(item);
      return Expanded(
        child: GestureDetector(
          onTap: () => _scrollToSection(item['section'] as ExploreSection),
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
                Icon(item['icon'] as IconData, size: 22.r, color: AppColor.primaryColor),
                Gap(8.h),
                Text(item['label'] as String, style: AppTextStyle.normalBody.copyWith(fontWeight: FontWeight.w600)),
                Text(item['sub'] as String, style: AppTextStyle.smallBody.copyWith(color: Colors.grey)),
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
  // Widget _buildTicketRow(Product ticket, int index) {
  //   final isExpanded = _expandedTicketIndex == index;
  //   // final qty = _quantities[index] ?? 1;
  //   final currentInCart = Hive.box<HiveCartModel>(AppConstants.cartBox)
  //       .values
  //       .where((e) => e.id == ticket.id)
  //       .fold(0, (sum, e) => sum + e.productsQTY);

  //   final qty = currentInCart > 0 
  //       ? (_quantities[index] ?? currentInCart)
  //       : (_quantities[index] ?? 1);
  //   final price = ticket.price ?? 0.0;
  //   final total = price * qty;

  //   return AnimatedContainer(
  //     duration: const Duration(milliseconds: 200),
  //     margin: EdgeInsets.only(bottom: 8.h),
  //     decoration: BoxDecoration(
  //       color:
  //           isExpanded ? AppColor.primaryColor.withOpacity(0.06) : Colors.white,
  //       borderRadius: BorderRadius.circular(10.r),
  //       border: Border.all(
  //         color: isExpanded
  //             ? AppColor.primaryColor.withOpacity(0.3)
  //             : Colors.grey[200]!,
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         // header row
  //         InkWell(
  //           borderRadius: BorderRadius.circular(10.r),
  //           onTap: () => setState(() {
  //             _expandedTicketIndex = isExpanded ? null : index;
  //             if (!_quantities.containsKey(index)) _quantities[index] = 1;
  //           }),
  //           child: Padding(
  //             padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(ticket.name ?? '',
  //                           style: AppTextStyle.normalBody
  //                               .copyWith(fontWeight: FontWeight.w600)),
  //                       if (ticket.brand != null)
  //                         Text(ticket.brand!,
  //                             style: AppTextStyle.smallBody.copyWith(
  //                                 color: Colors.grey, fontSize: 11.sp)),
  //                     ],
  //                   ),
  //                 ),
  //                 Text('${price.toStringAsFixed(2)} €',
  //                     style: AppTextStyle.normalBody.copyWith(
  //                         decoration: TextDecoration.underline,
  //                         fontSize: 14.sp)),
  //               ],
  //             ),
  //           ),
  //         ),
  //         // expanded: quantity + checkout
  //         if (isExpanded)
  //           Padding(
  //             padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
  //             child: Container(
  //               padding: EdgeInsets.all(12.r),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(8.r),
  //                 border: Border.all(color: Colors.grey[200]!),
  //               ),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Text('Quantità',
  //                           style: AppTextStyle.smallBody
  //                               .copyWith(color: Colors.grey)),
  //                       const Spacer(),
  //                       _qtyButton(
  //                         icon: Icons.remove,
  //                         onTap: qty > 1
  //                             ? () =>
  //                                 setState(() => _quantities[index] = qty - 1)
  //                             : null,
  //                       ),
  //                       Padding(
  //                         padding: EdgeInsets.symmetric(horizontal: 12.w),
  //                         child: Text('$qty',
  //                             style: AppTextStyle.normalBody
  //                                 .copyWith(fontWeight: FontWeight.w600)),
  //                       ),
  //                       _qtyButton(
  //                         icon: Icons.add,
  //                         onTap: () =>
  //                             setState(() => _quantities[index] = qty + 1),
  //                       ),
  //                     ],
  //                   ),
  //                   Divider(height: 16.h, color: Colors.grey[200]),
  //                   Row(
  //                     children: [
  //                       Text('Totale',
  //                           style: AppTextStyle.smallBody
  //                               .copyWith(color: Colors.grey)),
  //                       Gap(8.w),
  //                       Text('${total.toStringAsFixed(2)} €',
  //                           style: AppTextStyle.normalBody
  //                               .copyWith(fontWeight: FontWeight.w700)),
  //                       const Spacer(),
  //                       // FIX: botón checkout agrega al carrito Hive
  //                       ValueListenableBuilder<Box<HiveCartModel>>(
  //                         valueListenable:
  //                             Hive.box<HiveCartModel>(AppConstants.cartBox)
  //                                 .listenable(),
  //                         builder: (context, box, _) {
  //                           final inCart =
  //                               box.values.any((e) => e.id == ticket.id);
  //                           return SizedBox(
  //                             height: 36.h,
  //                             child: ElevatedButton(
  //                               onPressed: () async {
  //                                 final existingKeys = box.keys.where(
  //                                   (k) => box.get(k)?.id == ticket.id,
  //                                 ).toList();

  //                                 if (existingKeys.isNotEmpty) {
  //                                   final key = existingKeys.first;
  //                                   final old = box.get(key)!;
  //                                   await box.put(key, HiveCartModel(
  //                                     id: old.id,
  //                                     name: old.name,
  //                                     code: old.code,
  //                                     thumbnail: old.thumbnail,
  //                                     subTotal: old.subTotal + (price * qty),
  //                                     productsQTY: old.productsQTY + qty,
  //                                   ));
  //                                 } else {
  //                                   await box.add(HiveCartModel(
  //                                     id: ticket.id,
  //                                     name: ticket.name ?? 'Biglietto',
  //                                     code: ticket.code ?? '',
  //                                     thumbnail: ticket.thumbnail ?? '',
  //                                     subTotal: price * qty,
  //                                     productsQTY: qty,
  //                                   ));
  //                                 }
  //                                 setState(() => _expandedTicketIndex = null);
  //                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                                   behavior: SnackBarBehavior.floating,
  //                                   content: Text('${ticket.name} aggiunto al carrello'),
  //                                   backgroundColor: Colors.green,
  //                                 ));
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 backgroundColor: inCart
  //                                     ? Colors.grey
  //                                     : AppColor.primaryColor,
  //                                 foregroundColor: Colors.white,
  //                                 shape: RoundedRectangleBorder(
  //                                     borderRadius: BorderRadius.circular(8.r)),
  //                                 padding:
  //                                     EdgeInsets.symmetric(horizontal: 20.w),
  //                               ),
  //                               child:
  //                                   Text(inCart ? 'Nel carrello' : 'Aggiungi al carrello'),
  //                             ),
  //                           );
  //                         },
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildTicketRow(Product ticket, int index) {
    final isExpanded = _expandedTicketIndex == index;
    final box = Hive.box<HiveCartModel>(AppConstants.cartBox);
    final price = ticket.price ?? 0.0;

    return ValueListenableBuilder<Box<HiveCartModel>>(
      valueListenable: box.listenable(),
      builder: (context, cartBox, _) {
        // ── leer qty REAL del carrito ──────────────────────────────
        final cartKey = cartBox.keys.firstWhere(
          (k) => cartBox.get(k)?.id == ticket.id,
          orElse: () => null,
        );
        final cartItem = cartKey != null ? cartBox.get(cartKey) : null;
        final inCart = cartItem != null;

        // qty mostrado: si está en carrito usa ese valor, si no usa el local
        final qty = inCart
            ? cartItem!.productsQTY
            : (_quantities[index] ?? 1);
        final total = price * qty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: isExpanded
                ? AppColor.primaryColor.withOpacity(0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isExpanded
                  ? AppColor.primaryColor.withOpacity(0.3)
                  : Colors.grey[200]!,
            ),
          ),
          child: Column(
            children: [
              // ── header ──────────────────────────────────────────
              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: () => setState(() {
                  _expandedTicketIndex = isExpanded ? null : index;
                  if (!_quantities.containsKey(index)) {
                    _quantities[index] = inCart ? qty : 1;
                  }
                }),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 14.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ticket.name ?? '',
                                style: AppTextStyle.normalBody.copyWith(
                                    fontWeight: FontWeight.w600)),
                            if (ticket.brand != null)
                              Text(ticket.brand!,
                                  style: AppTextStyle.smallBody.copyWith(
                                      color: Colors.grey, fontSize: 11.sp)),
                          ],
                        ),
                      ),
                      // badge qty si está en carrito
                      if (inCart)
                        Container(
                          margin: EdgeInsets.only(right: 8.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text('×$qty',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600)),
                        ),
                      Text('${price.toStringAsFixed(2)} €',
                          style: AppTextStyle.normalBody.copyWith(
                              decoration: TextDecoration.underline,
                              fontSize: 14.sp)),
                    ],
                  ),
                ),
              ),

              // ── expanded ─────────────────────────────────────────
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
                                  ? () async {
                                      final newQty = qty - 1;
                                      if (inCart) {
                                        // ── actualiza carrito directamente ──
                                        await cartBox.put(
                                          cartKey,
                                          HiveCartModel(
                                            id: cartItem!.id,
                                            name: cartItem.name,
                                            code: cartItem.code,
                                            thumbnail: cartItem.thumbnail,
                                            subTotal: price * newQty,
                                            productsQTY: newQty,
                                          ),
                                        );
                                      } else {
                                        setState(() =>
                                            _quantities[index] = newQty);
                                      }
                                    }
                                  : null,
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 12.w),
                              child: Text('$qty',
                                  style: AppTextStyle.normalBody.copyWith(
                                      fontWeight: FontWeight.w600)),
                            ),
                            _qtyButton(
                              icon: Icons.add,
                              onTap: () async {
                                final newQty = qty + 1;
                                if (inCart) {
                                  // ── actualiza carrito directamente ──
                                  await cartBox.put(
                                    cartKey,
                                    HiveCartModel(
                                      id: cartItem!.id,
                                      name: cartItem.name,
                                      code: cartItem.code,
                                      thumbnail: cartItem.thumbnail,
                                      subTotal: price * newQty,
                                      productsQTY: newQty,
                                    ),
                                  );
                                } else {
                                  setState(
                                      () => _quantities[index] = newQty);
                                }
                              },
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
                                style: AppTextStyle.normalBody.copyWith(
                                    fontWeight: FontWeight.w700)),
                            const Spacer(),
                            SizedBox(
                              height: 36.h,
                              child: ElevatedButton(
                                onPressed: inCart
                                    // ── ya en carrito: ir al tab ──
                                    ? () {
                                        ref
                                            .read(selectedIndexProvider
                                                .notifier)
                                            .state = 3;
                                        ref
                                            .read(bottomTabControllerProvider)
                                            .jumpToPage(3);
                                      }
                                    // ── no en carrito: agregar y navegar ──
                                    : () async {
                                        await cartBox.add(HiveCartModel(
                                          id: ticket.id,
                                          name:
                                              ticket.name ?? 'Biglietto',
                                          code: ticket.code ?? '',
                                          thumbnail:
                                              ticket.thumbnail ?? '',
                                          subTotal: price * qty,
                                          productsQTY: qty,
                                        ));
                                        setState(() =>
                                            _expandedTicketIndex = null);
                                        ref
                                            .read(selectedIndexProvider
                                                .notifier)
                                            .state = 3;
                                        ref
                                            .read(bottomTabControllerProvider)
                                            .jumpToPage(3);
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: inCart
                                      ? Colors.green
                                      : AppColor.primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.r)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w),
                                ),
                                // texto cambia según estado
                                child: Text(inCart
                                    ? 'Vai al carrello'
                                    : 'Aggiungi al carrello'),
                              ),
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
      },
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Gap(30.h), const LogoSection()],
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
                  // IconButton(
                  //     icon: const Icon(Icons.filter_list), onPressed: () {}),
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
                  _sectionTitle('Biglietti', key: _bigliettiKey),
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
                  _sectionTitle('Orari', key: _orariKey),
                  _buildOrariSection(),
                  Gap(8.h),
                  _sectionTitle('Posizione', key: _posizioneKey),
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

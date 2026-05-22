import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/brand_controller/brand.dart';
import 'package:readypos_flutter/controllers/collection_controller/collection.dart';
import 'package:readypos_flutter/controllers/masterpiece_controller/masterpiece_controller.dart';
import 'package:readypos_flutter/models/brand/brand.dart';
import 'package:readypos_flutter/models/collection/collection.dart';
import 'package:readypos_flutter/models/masterpiece/masterpiece.dart';
import 'package:readypos_flutter/routes.dart';

// ─── Resultado unificado ───────────────────────────────────────────────────

enum _ResultType { collection, artist, masterpiece }

class _SearchResult {
  final _ResultType type;
  final String title;
  final String? subtitle;
  final String? thumbnail;
  final Object payload; // Collection | Brand | Masterpiece

  const _SearchResult({
    required this.type,
    required this.title,
    this.subtitle,
    this.thumbnail,
    required this.payload,
  });
}

// ─── Widget de búsqueda (modal bottom sheet + lista) ──────────────────────

class GlobalSearchSheet extends ConsumerStatefulWidget {
  const GlobalSearchSheet({super.key});

  @override
  ConsumerState<GlobalSearchSheet> createState() => _GlobalSearchSheetState();
}

class _GlobalSearchSheetState extends ConsumerState<GlobalSearchSheet> {
  final _ctrl = TextEditingController();
  List<_SearchResult> _results = [];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Filtra en memoria — todos los datos ya están cargados en los providers
  void _search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      setState(() => _results = []);
      return;
    }

    final collections =
        ref.read(collectionControllerProvider.notifier).collections ?? [];
    final artists = ref.read(brandControllerProvider.notifier).brands ?? [];
    final masterpieces =
        ref.read(masterpieceControllerProvider.notifier).masterpieces ?? [];

    final results = <_SearchResult>[];

    for (final c in collections) {
      if (c.name.toLowerCase().contains(q) ||
          (c.description?.toLowerCase().contains(q) ?? false)) {
        results.add(_SearchResult(
          type: _ResultType.collection,
          title: c.name,
          subtitle: c.description,
          thumbnail: c.thumbnail,
          payload: c,
        ));
      }
    }

    for (final a in artists) {
      if (a.name.toLowerCase().contains(q)) {
        results.add(_SearchResult(
          type: _ResultType.artist,
          title: a.name,
          subtitle: 'Artista',
          thumbnail: a.thumbnail,
          payload: a,
        ));
      }
    }

    for (final m in masterpieces) {
      if (m.title.toLowerCase().contains(q) ||
          (m.brandName?.toLowerCase().contains(q) ?? false)) {
        results.add(_SearchResult(
          type: _ResultType.masterpiece,
          title: m.title,
          subtitle: m.brandName,
          thumbnail: m.thumbnail,
          payload: m,
        ));
      }
    }

    setState(() => _results = results);
  }

  void _onTap(_SearchResult result) {
    Navigator.pop(context); // chiude il sheet
    switch (result.type) {
      case _ResultType.collection:
        Navigator.pushNamed(context, Routes.collectionDetail,
            arguments: result.payload as Collection);
        break;
      case _ResultType.artist:
        Navigator.pushNamed(context, Routes.artistDetail,
            arguments: result.payload as Brand);
        break;
      case _ResultType.masterpiece:
        Navigator.pushNamed(context, Routes.masterpieceDetail,
            arguments: result.payload as Masterpiece);
        break;
    }
  }

  IconData _iconFor(_ResultType t) {
    switch (t) {
      case _ResultType.collection:
        return Icons.collections_outlined;
      case _ResultType.artist:
        return Icons.person_outline;
      case _ResultType.masterpiece:
        return Icons.image_outlined;
    }
  }

  String _labelFor(_ResultType t) {
    switch (t) {
      case _ResultType.collection:
        return 'Collezione';
      case _ResultType.artist:
        return 'Artista';
      case _ResultType.masterpiece:
        return 'Opera';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollCtrl) => Column(
        children: [
          // ── handle ──────────────────────────────────────────────────────
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // ── barra de búsqueda ────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: TextField(
              controller: _ctrl,
              autofocus: true,
              onChanged: _search,
              decoration: InputDecoration(
                hintText: 'Cerca opere, artisti, collezioni...',
                hintStyle:
                    AppTextStyle.normalBody.copyWith(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _ctrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _ctrl.clear();
                          _search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1.w),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide:
                      BorderSide(color: AppColor.primaryColor, width: 1.5.w),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),

          // ── resultados ───────────────────────────────────────────────────
          Expanded(
            child: _ctrl.text.isEmpty
                // estado vacío — categorías de sugerencia
                ? _buildEmptyState()
                : _results.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off,
                                size: 48.r, color: Colors.grey[300]),
                            Gap(12.h),
                            Text('Nessun risultato per "${_ctrl.text}"',
                                style: AppTextStyle.normalBody
                                    .copyWith(color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: scrollCtrl,
                        itemCount: _results.length,
                        separatorBuilder: (_, __) => Divider(
                            height: 0, indent: 72.w, color: Colors.grey[200]),
                        itemBuilder: (_, i) {
                          final r = _results[i];
                          return ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 4.h),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child:
                                  r.thumbnail != null && r.thumbnail!.isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: r.thumbnail!,
                                          width: 48.w,
                                          height: 48.w,
                                          fit: BoxFit.cover,
                                          errorWidget: (_, __, ___) =>
                                              _placeholderIcon(r.type),
                                        )
                                      : _placeholderIcon(r.type),
                            ),
                            title: Text(r.title,
                                style: AppTextStyle.normalBody
                                    .copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            subtitle: Row(
                              children: [
                                Icon(_iconFor(r.type),
                                    size: 12.r, color: AppColor.primaryColor),
                                Gap(4.w),
                                Text(_labelFor(r.type),
                                    style: AppTextStyle.smallBody.copyWith(
                                        color: AppColor.primaryColor,
                                        fontSize: 11.sp)),
                                if (r.subtitle != null &&
                                    r.subtitle!.isNotEmpty) ...[
                                  Text(' · ',
                                      style: AppTextStyle.smallBody
                                          .copyWith(color: Colors.grey)),
                                  Expanded(
                                    child: Text(r.subtitle!,
                                        style: AppTextStyle.smallBody
                                            .copyWith(color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ],
                            ),
                            trailing: Icon(Icons.chevron_right,
                                color: Colors.grey[400]),
                            onTap: () => _onTap(r),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cerca tra',
              style: AppTextStyle.normalBody
                  .copyWith(color: Colors.grey, fontSize: 13.sp)),
          Gap(16.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _chip(Icons.collections_outlined, 'Collezioni'),
              _chip(Icons.person_outline, 'Artisti'),
              _chip(Icons.image_outlined, 'Opere'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) => Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.r, color: AppColor.primaryColor),
            Gap(6.w),
            Text(label,
                style: AppTextStyle.smallBody
                    .copyWith(color: AppColor.primaryColor)),
          ],
        ),
      );

  Widget _placeholderIcon(_ResultType t) => Container(
        width: 48.w,
        height: 48.w,
        color: Colors.grey[100],
        child: Icon(_iconFor(t), color: Colors.grey[400], size: 24.r),
      );
}

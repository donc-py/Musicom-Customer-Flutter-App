import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/models/event/event.dart';

class EventDetailView extends StatelessWidget {
  final Event event;
  const EventDetailView({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final dateStart = DateFormat('d MMMM yyyy · HH:mm').format(event.startsAt);
    final dateEnd = event.endsAt != null
        ? DateFormat('d MMMM yyyy · HH:mm').format(event.endsAt!)
        : null;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260.h,
            pinned: true,
            surfaceTintColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: event.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: event.thumbnail!,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          Container(color: Colors.grey[200]),
                    )
                  : Container(color: Colors.grey[200]),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: AppTextStyle.title),
                  Gap(16.h),
                  // fecha y lugar en chips
                  _infoRow(Icons.calendar_today, dateStart),
                  if (dateEnd != null) ...[
                    Gap(8.h),
                    _infoRow(Icons.event_available, 'Fine: $dateEnd'),
                  ],
                  if (event.location != null) ...[
                    Gap(8.h),
                    _infoRow(Icons.location_on, event.location!),
                  ],
                  if (event.description != null) ...[
                    Gap(20.h),
                    Divider(color: AppColor.borderColor),
                    Gap(12.h),
                    Text('Descrizione',
                        style: AppTextStyle.normalBody
                            .copyWith(fontWeight: FontWeight.bold)),
                    Gap(8.h),
                    Text(event.description!,
                        style: AppTextStyle.normalBody
                            .copyWith(color: Colors.grey[700])),
                  ],
                  Gap(32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16.r, color: AppColor.primaryColor),
          Gap(8.w),
          Expanded(
            child: Text(text,
                style:
                    AppTextStyle.normalBody.copyWith(color: Colors.grey[700])),
          ),
        ],
      );
}

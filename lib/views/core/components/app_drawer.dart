import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_constants.dart';
import 'package:readypos_flutter/config/app_text.dart';
import 'package:readypos_flutter/controllers/auth_controller/auth_controller.dart';
import 'package:readypos_flutter/routes.dart';
import 'package:readypos_flutter/utils/context_less_navigation.dart';
import 'package:readypos_flutter/views/museum/contatti_view.dart';
import 'package:readypos_flutter/views/museum/explore_view.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.78,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header logo + title ──────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                children: [
                  // Usa tu logo asset si lo prefieres:
                  // Assets.pngs.icon.image(width: 36.w)
                  Icon(Icons.museum_outlined,
                      size: 32.r, color: AppColor.primaryColor),
                  Gap(12.w),
                  Text('MUCICOM',
                      style: AppTextStyle.title.copyWith(
                          fontSize: 20.sp, fontWeight: FontWeight.w700)),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey[200]),

            // ── Nav items ────────────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                children: [
                  _DrawerItem(
                    icon: Icons.home_outlined,
                    label: 'Home',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, Routes.core, (_) => false);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.info_outline,
                    label: 'Esplora il MUCICOM',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ExploreView()));
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.collections_outlined,
                    label: 'Le nostre Collezioni',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.collectionsListView);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.image_outlined,
                    label: 'I nostri Masterpiece',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.masterpiecesListView);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline,
                    label: 'I nostri Artisti',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.artistsListView);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.article_outlined,
                    label: 'News',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.newsListView);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.event_outlined,
                    label: 'Eventi',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.eventsListView);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'E-shop',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.productView);
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.contacts_outlined,
                    label: 'Contatti',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ContattiView()));
                    },
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey[200]),

            // ── Footer: perfil + logout ───────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColor.primaryColor.withOpacity(0.15),
                    child: Icon(Icons.person,
                        color: AppColor.primaryColor, size: 22.r),
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amanda',
                            style: AppTextStyle.normalBody
                                .copyWith(fontWeight: FontWeight.w600)),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, Routes.adminProfile);
                          },
                          child: Text('Visualizza profilo',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColor.primaryColor,
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                  ),
                  // logout
                  IconButton(
                    icon:
                        Icon(Icons.logout, size: 22.r, color: Colors.grey[600]),
                    onPressed: () {
                      //Navigator.pop(context);
                      //ref.read(authControllerProvider.notifier).logout(context);
                      Box authBox = Hive.box(AppConstants.authBox);
                      authBox.clear().then(
                            (value) => context.nav.pushNamedAndRemoveUntil(
                                Routes.login, (route) => false),
                          );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Item helper ─────────────────────────────────────────────────────────────

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 22.r, color: Colors.grey[700]),
      title:
          Text(label, style: AppTextStyle.normalBody.copyWith(fontSize: 15.sp)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      horizontalTitleGap: 8.w,
    );
  }
}

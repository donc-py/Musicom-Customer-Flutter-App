import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:readypos_flutter/config/app_color.dart';
import 'package:readypos_flutter/config/app_text.dart';

class ContattiView extends StatelessWidget {
  const ContattiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatti'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Contatti ─────────────────────────────────────────────────
            Text('Contatti',
                style: AppTextStyle.title
                    .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
            Gap(16.h),
            _ContactRow(
              icon: Icons.support_agent_outlined,
              label: 'Reception',
              value: '+39 095 98 68 98',
              onTap: () {
                // TODO: launch phone
              },
            ),
            Gap(12.h),
            _ContactRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: 'info@mucicom.com',
              onTap: () {
                // TODO: launch email
              },
            ),

            Gap(32.h),

            // ── Posizione ─────────────────────────────────────────────────
            Text('Posizione',
                style: AppTextStyle.title
                    .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
            Gap(16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        style: AppTextStyle.smallBody
                            .copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            Gap(16.h),
            // mapa placeholder
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(Icons.map, size: 48.r, color: Colors.grey[400]),
              ),
            ),

            Gap(32.h),

            // ── Social ───────────────────────────────────────────────────
            Text('Social',
                style: AppTextStyle.title
                    .copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700)),
            Gap(16.h),
            Row(
              children: [
                _SocialButton(
                    icon: Icons.facebook,
                    color: const Color(0xFF1877F2),
                    onTap: () {}),
                Gap(16.w),
                _SocialButton(
                    icon: Icons.camera_alt_outlined,
                    color: const Color(0xFFE1306C),
                    onTap: () {}),
                Gap(16.w),
                _SocialButton(
                    icon: Icons.chat_outlined,
                    color: const Color(0xFF25D366),
                    onTap: () {}),
              ],
            ),

            Gap(32.h),
          ],
        ),
      ),
    );
  }
}

// ─── helpers ─────────────────────────────────────────────────────────────────

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24.r, color: Colors.grey[600]),
            Gap(12.w),
            Expanded(
              child: Text(label,
                  style: AppTextStyle.normalBody
                      .copyWith(fontWeight: FontWeight.w500)),
            ),
            Text(value,
                style: AppTextStyle.normalBody.copyWith(
                    decoration: TextDecoration.underline,
                    color: AppColor.primaryColor,
                    fontSize: 14.sp)),
          ],
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton(
      {required this.icon, required this.color, required this.onTap});

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Icon(icon, size: 24.r, color: color),
      ),
    );
  }
}

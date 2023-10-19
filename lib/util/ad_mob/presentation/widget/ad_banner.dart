import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/util/ad_mob/application/ad_mob_service.dart';

class AdBanner extends ConsumerWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = ref.watch(adBannerService);

    return SizedBox(
      height: 50.h,
      width: 320.w,
      child: banner == null
          ? Container()
          : AdWidget(
              ad: banner,
            ),
    );
  }
}

// バナー広告のプロバイダ
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/constant/ad_unit_id.dart';
import 'package:share_kakeibo/enum/flavor.dart';
import 'package:share_kakeibo/util/logger.dart';

final adBannerService =
    StateNotifierProvider.autoDispose<AdBannerService, BannerAd?>(
  (ref) => flavor.isDev
      // 開発用のバナー広告ユニットID
      ? AdBannerService(
          iosAdUnitId: AdUnitID.iosAdBannerDebug,
          androidAdUnitId: AdUnitID.androidAdBannerDebug,
        )
      // 本番用のバナー広告ユニットID
      : AdBannerService(
          iosAdUnitId: AdUnitID.iosAdBannerRelease,
          androidAdUnitId: AdUnitID.androidAdBannerRelease,
        ),
);

class AdBannerService extends StateNotifier<BannerAd?> {
  AdBannerService({
    required this.iosAdUnitId,
    required this.androidAdUnitId,
  }) : super(null) {
    createBannerAd();
  }

  final String iosAdUnitId;
  final String androidAdUnitId;

  String getBannerAdUnitId() {
    var adId = '';
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isIOS) {
      // iOSの広告ユニットID
      adId = iosAdUnitId;
    } else if (Platform.isAndroid) {
      // Androidの広告ユニットID
      adId = androidAdUnitId;
    }
    return adId;
  }

  // 広告が読み込まれたときなどのライフサイクルイベントをリッスンしログを出力
  // 参照：https://developers.google.com/admob/flutter/banner?hl=ja#banner_ad_events
  BannerAdListener get adListener => _adListener;
  final _adListener = BannerAdListener(
    onAdLoaded: (ad) => logger.i('Ad loaded: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      logger.e('Ad failed to load: ${ad.adUnitId}, $error.');
    },
    onAdOpened: (ad) => logger.i('Ad opened: ${ad.adUnitId}.'),
    onAdClosed: (ad) => logger.i('Ad closed: ${ad.adUnitId}.'),
    onAdWillDismissScreen: (ad) =>
        logger.i('Ad will dismiss screen: ${ad.adUnitId}.'),
    onAdImpression: (ad) => logger.i('Ad impression: ${ad.adUnitId}.'),
    onPaidEvent: (ad, valueMicros, precision, currencyCode) =>
        logger.i('paid event: ${ad.adUnitId},'
            ' value micros $valueMicros'
            ' precision $precision'
            ' currency code $currencyCode'),
  );

  // 広告をインスタンス化
  // 参照：https://developers.google.com/admob/flutter/banner?hl=ja#instantiate_ad
  void createBannerAd() {
    if (mounted) {
      state = BannerAd(
        listener: _adListener,
        // バナーのサイズ：https://developers.google.com/admob/flutter/banner?hl=ja#banner_sizes
        size: AdSize.banner,
        adUnitId: getBannerAdUnitId(),
        request: const AdRequest(),
      )..load();
    }
  }
}

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/enum/flavor.dart';

// remote configのprovider
final remoteConfigService = FutureProvider<FirebaseRemoteConfig>(
  (ref) async {
    final rc = FirebaseRemoteConfig.instance;

    // 開発環境ごとにintervalを分ける
    final interval = flavor.isDev ? Duration.zero : const Duration(hours: 1);

    // タイムアウトとフェッチのインターバル時間を設定する
    await rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: interval,
      ),
    );
    return rc;
  },
);

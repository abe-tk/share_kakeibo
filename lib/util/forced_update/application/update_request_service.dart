import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_kakeibo/enum/update_request_type.dart';
import 'package:share_kakeibo/util/forced_update/application/remote_config_service.dart';
import 'package:share_kakeibo/util/forced_update/domain/update_info.dart';
import 'package:share_kakeibo/util/shared_preferences/data/shared_preferences_repository.dart';
import 'package:version/version.dart';

final updateRequestService = FutureProvider<UpdateRequestType>((ref) async {
  final remoteConfig = await ref.watch(remoteConfigService.future);
  await remoteConfig.fetchAndActivate();
  // Firebase の RemoteConfigコンソールで指定したキーを使って値を取得
  final string = remoteConfig.getString('update_info');
  if (string.isEmpty) {
    return UpdateRequestType.not;
  }
  // JSON to Map
  final map = json.decode(string) as Map<String, Object?>;
  // Map(JSON) to Entity
  final updateInfo = UpdateInfo.fromJson(map);

  // 現在のアプリケーションを取得
  final appPackageInfo = await PackageInfo.fromPlatform();
  final appVersion = Version.parse(appPackageInfo.version);

  // shared_preferencesで保存ている「キャンセル」を押下した日時を取得
  final latestVersion = Version.parse(updateInfo.latestVersion);
  final requiredVersion = Version.parse(updateInfo.requiredVersion);
  final enabledAt = updateInfo.enabledAt;

  // shared_preferencesで保存ている「キャンセル」を押下した日時を取得
  final cancelledUpdateDateTime = await ref
      .watch(sharedPreferencesRepositoryProvider)
      .fetch<String>(SharedPreferencesKey.cancelledUpdateDateTime);

  // 現在のバージョンより新しいバージョンが指定されているか
  final hasNewVersion =
      latestVersion > appVersion || requiredVersion > appVersion;

  // ダイアログ表示が有効かどうか
  late bool isEnabled;
  if (enabledAt.isBefore(DateTime.now())) {
    isEnabled = cancelledUpdateDateTime == null ||
        enabledAt.isAfter(DateTime.parse(cancelledUpdateDateTime));
  } else {
    isEnabled = false;
  }

  if (!isEnabled || !hasNewVersion) {
    return UpdateRequestType.not;
  }
  return latestVersion > appVersion && requiredVersion <= appVersion
      ? UpdateRequestType.cancelable
      : UpdateRequestType.forcibly;
});
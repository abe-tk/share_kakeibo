import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/enum/update_request_type.dart';
import 'package:share_kakeibo/extension/text_theme.dart';
import 'package:share_kakeibo/util/forced_update/application/update_request_service.dart';
import 'package:share_kakeibo/util/shared_preferences/data/shared_preferences_repository.dart';
import 'package:share_kakeibo/util/url_launcher/application/url_launcher_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UpdateDialog extends ConsumerWidget {
  const UpdateDialog({
    super.key,
    required this.updateRequestType,
  });

  final UpdateRequestType? updateRequestType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      // AndroidのBackボタンで閉じられないようにする
      onWillPop: () async => false,
      child: AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        title: Text(
          'アプリが更新されました',
          style: context.titleLargeBold,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('最新バージョンのダウンロードをお願いします。'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (updateRequestType == UpdateRequestType.cancelable)
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref
                          .watch(sharedPreferencesRepositoryProvider)
                          .save<String>(
                            SharedPreferencesKey.cancelledUpdateDateTime,
                            DateTime.now().toString(),
                          );
                      ref.invalidate(updateRequestService);
                    },
                    child: Text(
                      'キャンセル',
                      style: context.bodyMediumGrey,
                    ),
                  ),
                const Gap(8),
                TextButton(
                  onPressed: () async {
                    // App Store or Google Play に飛ばす処理
                    await ref.read(urlLauncherService).launch(
                          url: Platform.isIOS
                              ? 'https://apps.apple.com/app/id1638570813'
                              : 'https://play.google.com/store/apps/details?id=com.myApp.shareKakeibo',
                          // Androidではデフォルトだとアプリ内WebViewでストアが開くので、Playストアアプリで開くように指定
                          launchMode: LaunchMode.externalApplication,
                        );
                  },
                  child: Text(
                    'アップデートする',
                    style: context.bodyMediumBold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

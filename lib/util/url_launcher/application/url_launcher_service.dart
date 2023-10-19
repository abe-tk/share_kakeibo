import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';
import 'package:url_launcher/url_launcher.dart';

final urlLauncherService = Provider((_) => UrlLauncherService());

class UrlLauncherService {
  Future<void> launch({
    required String url,
    // LaunchModeのデフォルトはOSのデフォルト動作
    LaunchMode launchMode = LaunchMode.platformDefault,
  }) async {
    final uri = Uri.parse(
      url,
    );
    await _launchUrl(uri, launchMode);
  }

  Future<void> _launchUrl(Uri uri, LaunchMode launchMode) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: launchMode);
    } else {
      // urlの指定さえ間違っていなければ起きないエラーのため、presentation層でハンドリングは行っていない
      final Error error = ArgumentError('Could not launch $uri');
      logger.e(error);
      throw error;
    }
  }
}

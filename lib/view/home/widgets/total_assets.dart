// constant
import 'package:share_kakeibo/constant/number_format.dart';
import 'package:share_kakeibo/constant/colors.dart';
// view_model
import 'package:share_kakeibo/view_model/home/widgets/total_assets_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TotalAssets extends StatefulHookConsumerWidget {
  const TotalAssets({Key? key}) : super(key: key);

  @override
  _TotalAssetsState createState() => _TotalAssetsState();
}

class _TotalAssetsState extends ConsumerState<TotalAssets> {

  @override
  void initState() {
    super.initState();
    // ref.read(totalAssetsProvider.notifier).calcTotalAssets();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // エラーの出ていた処理
      ref.read(totalAssetsViewModelProvider.notifier).calcTotalAssets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(totalAssetsViewModelProvider);
    final _isObscure = useState(true);
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 60, right: 16, bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: boxShadowColor,
              spreadRadius: 1.0,
            ),
          ],
          color: boxColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          leading: Text('総資産額', style: TextStyle(color: detailIconColor),),
          title: Text(
            _isObscure.value ? '*** 円' : '${formatter.format(total)} 円',
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              _isObscure.value ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              _isObscure.value = !_isObscure.value;
            },
          ),
        ),
      ),
    );
  }
}

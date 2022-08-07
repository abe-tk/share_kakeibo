/// component
import 'package:share_kakeibo/components/number_format.dart';

/// view_model
import 'package:share_kakeibo/view_model/home/home_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TotalAssets extends HookConsumerWidget {
  TotalAssets({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final _visible = useState(false);
    return GestureDetector(
      onTap: () {
        _visible.value = !_visible.value;
      },
      child: (_visible.value != false)
          ? Container(
        height: 100,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    '総資産額',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.arrow_drop_up),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${formatter.format(homeViewModel.totalAssets)} 円',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          : Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: const Text(
                    '総資産額',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.arrow_drop_down),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


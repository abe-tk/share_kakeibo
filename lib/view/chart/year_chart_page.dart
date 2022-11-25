import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class YearChartPage extends StatefulHookConsumerWidget {
  const YearChartPage({Key? key}) : super(key: key);

  @override
  _YearChartPageState createState() => _YearChartPageState();
}

class _YearChartPageState extends ConsumerState<YearChartPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(barChartStateProvider.notifier).setBarChartData(DateTime(DateTime.now().year));
    });
  }

  @override
  Widget build(BuildContext context) {
    final year = useState(DateTime(DateTime.now().year));
    return Scaffold(
      appBar: AppBar(
        title: const Text('支出の推移'),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('支出額の単位について'),
                    content: const Text('1K = 1,000 円\n1M = 1,000,000 円'),
                    actions: [
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.contact_support_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SelectYear(
              year: year.value,
              left: () {
                year.value = DateTime(year.value.year - 1);
                ref.read(barChartStateProvider.notifier).setBarChartData(year.value);
              },
              right: () {
                year.value = DateTime(year.value.year + 1);
                ref.read(barChartStateProvider.notifier).setBarChartData(year.value);
              },
            ),
            Expanded(
              child: AppBarChart(
                price: ref.watch(barChartStateProvider),
                verticalAxisValue: '円',
                horizontalAxisValue: '月',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

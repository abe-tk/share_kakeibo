/// component
import 'package:share_kakeibo/components/number_format.dart';

/// view
import 'package:share_kakeibo/view/home/home_pie_chart.dart';
import 'package:share_kakeibo/view/home/total_assets.dart';

/// view_model
import 'package:share_kakeibo/view_model/home/home_view_model.dart';
import 'package:share_kakeibo/view_model/add_event/add_event_view_model.dart';
import 'package:share_kakeibo/view_model/setting/room_info_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    ref.read(homeViewModelProvider).assetsCalc();
    ref.read(addEventViewModelProvider).setPaymentUser();
    ref.read(roomInfoViewModel).fetchRoom();
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  ref.watch(roomInfoViewModel).roomName ?? '',
                  style: const TextStyle(
                      color: Color(0xFF725B51), fontWeight: FontWeight.bold),
                ),
                leading: const Icon(
                  Icons.meeting_room_rounded,
                  color: Color(0xFF725B51),
                ),
              ),
              const SizedBox(height: 16),
              TotalAssets(),
              const SizedBox(height: 20),
              Container(
                height: 500,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await homeViewModel.oneMonthAgo();
                            homeViewModel.calc();
                          },
                          icon: const Icon(Icons.chevron_left),
                        ),
                        TextButton(
                          onPressed: () async {
                            await homeViewModel.selectMonth(context);
                            homeViewModel.calc();
                          },
                          child: Text(
                            '${DateFormat.yMMM('ja').format(homeViewModel.nowMonth)}の家計簿',
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await homeViewModel.oneMonthLater();
                            homeViewModel.calc();
                          },
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                    HomePieChart(),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          ListTile(
                            title: const Text('支出'),
                            trailing: Text(
                              '${formatter.format(homeViewModel.spendingPrice)} 円',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.red),
                            ),
                          ),
                          ListTile(
                            title: const Text('収入'),
                            trailing: Text(
                              '${formatter.format(homeViewModel.incomePrice)} 円',
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.green),
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            // leading: ,
                            trailing: Text(
                              '合計　${formatter.format(homeViewModel.totalPrice)} 円',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100)
            ],
          ),
        ),
      ),
    );
  }
}


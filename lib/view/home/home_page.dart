// components
import 'package:share_kakeibo/components/drawer_menu.dart';
// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/room/room_name_state.dart';
// view
import 'package:share_kakeibo/view/home/widgets/total_assets.dart';
import 'package:share_kakeibo/view/home/widgets/bp_pie_chart.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  Widget build(BuildContext context) {
    final roomNameState = ref.watch(roomNameProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settingPage');
              },
              icon: const Icon(Icons.settings),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBarBackGroundColor,
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: homeBoxColor,
                    border: Border(
                      bottom: BorderSide(
                        color: boxBorderSideColor,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.meeting_room_rounded, color: roomNameIconColor,),
                    title: Text(roomNameState, style: const TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
                Column(
                  children: [
                    // 総資産額
                    const TotalAssets(),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        height: 430,
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: boxShadowColor,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        // 当月の収支グラフ
                        child: const BpPieChart(),
                      ),
                    ),
                    // FABに被らないようにしている
                    const SizedBox(height: 50),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}

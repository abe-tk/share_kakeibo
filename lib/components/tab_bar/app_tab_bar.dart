import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class AppTabBar extends StatelessWidget {
  final String firstTab;
  final String secondTab;
  const AppTabBar({
    required this.firstTab,
    required this.secondTab,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: TabBar(
                indicatorColor: tabBarIndicatorColor,
                tabs: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      firstTab,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      secondTab,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// model
import 'package:share_kakeibo/model/chart_data.dart';
import 'package:share_kakeibo/model/room_member.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

final chartViewModelProvider =
    ChangeNotifierProvider((ref) => ChartViewModel());

class ChartViewModel extends ChangeNotifier {
  bool categoryDisplay = true;

  DateTime nowMonth = DateTime(DateTime.now().year, DateTime.now().month);

  late String roomCode;
  List<RoomMember> roomMemberList = [];

  int incomePrice = 0;
  int spendingPrice = 0;
  List<PieData> incomePieData = [];
  List<PieData> spendingPieData = [];
  List<UserChartData> incomeUserChartData = [];
  List<UserChartData> spendingUserChartData = [];
  List<ChartData> incomeChartData = [];
  List<ChartData> spendingChartData = [];

  List<Color> userColor = [];

  /// date
  Future<void> oneMonthAgo() async {
    nowMonth = DateTime(nowMonth.year, nowMonth.month - 1);
    notifyListeners();
  }

  Future<void> oneMonthLater() async {
    nowMonth = DateTime(nowMonth.year, nowMonth.month + 1);
    notifyListeners();
  }

  Future<void> selectMonth(BuildContext context) async {
    var selectedMonth = await showMonthPicker(
      context: context,
      initialDate: nowMonth,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selectedMonth == null) {
      return;
    } else {
      nowMonth = selectedMonth;
    }
    notifyListeners();
  }

  Future<void> setRoomMember() async {
    final codeSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = codeSnapshot.data();
    roomCode = data?['roomCode'];

    final memberSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('room')
        .get();
    final roomMembers =
        memberSnapshot.docs.map((snapshot) => RoomMember(snapshot)).toList();
    roomMemberList = roomMembers;

    for (int i = 0; i < roomMemberList.length; i++) {
      if (userColor.length < roomMemberList.length) {
        userColor.addAll([
          const Color(0xFFff6347),
          const Color(0xFF6495ed),
          const Color(0xFF66cdaa),
          const Color(0xFFf0e68c),
          const Color(0xFFe9967a),
          const Color(0xFFba55d3),
          const Color(0xFFffe4c4),
          const Color(0xFFdaa520),
        ]);
      }
      incomeUserChartData.add(
        UserChartData(
          category: roomMemberList[i].userName,
          price: 0,
          percent: 0.0,
          color: userColor[i],
          imgURL: roomMemberList[i].imgURL,
        ),
      );
    }

    for (int i = 0; i < roomMemberList.length; i++) {
      if (userColor.length < roomMemberList.length) {
        userColor.addAll([
          const Color(0xFFff6347),
          const Color(0xFF6495ed),
          const Color(0xFF66cdaa),
          const Color(0xFFf0e68c),
          const Color(0xFFe9967a),
          const Color(0xFFba55d3),
          const Color(0xFFffe4c4),
          const Color(0xFFdaa520),
        ]);
      }
      spendingUserChartData.add(
        UserChartData(
          category: roomMemberList[i].userName,
          price: 0,
          percent: 0.0,
          color: userColor[i],
          imgURL: roomMemberList[i].imgURL,
        ),
      );
    }
  }

  Future<void> changeChart(value) async {
    categoryDisplay = value;
  }

  void setInitialize() {
    roomMemberList = [];
    incomeUserChartData = [];
    spendingUserChartData = [];

    incomePrice = 0;
    spendingPrice = 0;
    incomePieData = [];
    spendingPieData = [];

    incomeChartData = [
      ChartData(
          '給与', 0, 0.0, const Color(0xFFffd700), Icons.account_balance_wallet),
      ChartData('賞与', 0, 0.0, const Color(0xFFff8c00), Icons.payments),
      ChartData('臨時収入', 0, 0.0, const Color(0xFFff6347), Icons.currency_yen),
      ChartData('未分類', 0, 0.0, Colors.grey, Icons.question_mark),
    ];
    spendingChartData = [
      ChartData('食費', 0, 0.0, const Color(0xFFffe4b5), Icons.rice_bowl),
      ChartData('外食費', 0, 0.0, const Color(0xFFfa8072), Icons.restaurant),
      ChartData('日用雑貨費', 0, 0.0, const Color(0xFFdeb887), Icons.shopping_cart),
      ChartData('交通・車両費', 0, 0.0, const Color(0xFFb22222),
          Icons.directions_car_outlined),
      ChartData('住居費', 0, 0.0, const Color(0xFFf4a460), Icons.house),
      ChartData('光熱費(電気)', 0, 0.0, const Color(0xFFf0e68c), Icons.bolt),
      ChartData('光熱費(ガス)', 0, 0.0, const Color(0xFFdc143c),
          Icons.local_fire_department),
      ChartData('水道費', 0, 0.0, const Color(0xFF00bfff), Icons.water_drop),
      ChartData('通信費', 0, 0.0, const Color(0xFFff00ff), Icons.speaker_phone),
      ChartData('レジャー費', 0, 0.0, const Color(0xFF3cb371), Icons.music_note),
      ChartData('教育費', 0, 0.0, const Color(0xFF9370db), Icons.school),
      ChartData('医療費', 0, 0.0, const Color(0xFFff7f50),
          Icons.local_hospital_outlined),
      ChartData('ファッション費', 0, 0.0, const Color(0xFFffc0cb), Icons.vaccines),
      ChartData('美容費', 0, 0.0, const Color(0xFFee82ee), Icons.spa),
      ChartData('未分類', 0, 0.0, Colors.grey, Icons.question_mark),
    ];

    userColor = [
      const Color(0xFFff6347),
      const Color(0xFF6495ed),
      const Color(0xFF66cdaa),
      const Color(0xFFf0e68c),
      const Color(0xFFe9967a),
      const Color(0xFFba55d3),
      const Color(0xFFffe4c4),
      const Color(0xFFdaa520),
    ];
  }

  Future setTotalPrice(largeCategory) async {
    int calcResult = 0;
    List<int> prices = [];
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('events')
        .where('registerDate', isEqualTo: nowMonth)
        .where('largeCategory', isEqualTo: largeCategory)
        .get();
    for (final document in snapshot.docs) {
      final event = document.data();
      final price = event['price'];
      prices.add(int.parse(price));
      int calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }

  Future setUserPrice(largeCategory, user) async {
    int calcResult = 0;
    List<int> prices = [];
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('events')
        .where('registerDate', isEqualTo: nowMonth)
        .where('largeCategory', isEqualTo: largeCategory)
        .where('paymentUser', isEqualTo: user)
        .get();
    for (final document in snapshot.docs) {
      final event = document.data();
      final price = event['price'];
      prices.add(int.parse(price));
      int calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }

  Future setPrice(largeCategory, smallCategory) async {
    int calcResult = 0;
    List<int> prices = [];
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('events')
        .where('registerDate', isEqualTo: nowMonth)
        .where('largeCategory', isEqualTo: largeCategory)
        .where('smallCategory', isEqualTo: smallCategory)
        .get();
    for (final document in snapshot.docs) {
      final event = document.data();
      final price = event['price'];
      prices.add(int.parse(price));
      int calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }

  double setPercent(smallPrice, largePrice) {
    double calcResult = 0;
    double percent = 0;
    if (smallPrice != 0) {
      percent = smallPrice / largePrice * 100;
    } else {
      percent = 0;
    }
    calcResult = percent;
    return calcResult;
  }

  setPieData(chartData, price) {
    List<PieData> pieData = [];
    for (int i = 0; i < chartData.length; i++) {
      pieData.add(
        PieData(
            title: '${chartData[i].category}',
            // '${chartData[i].category}(${chartData[i].percent != 0 ? chartData[i].percent!.round() : 0} ％)',
            percent: chartData[i].percent,
            color: chartData[i].color),
      );
    }
    if (price == 0) {
      pieData.add(
        PieData(
            title: 'データなし',
            percent: 100,
            color: const Color.fromRGBO(130, 132, 130, 1.0)),
      );
    }
    return pieData;
  }

  Future<void> calc() async {
    setInitialize();
    await setRoomMember();

    if (categoryDisplay == true) {
      // price
      incomePrice = await setTotalPrice('収入');
      spendingPrice = await setTotalPrice('支出');

      for (int i = 0; i < incomeChartData.length; i++) {
        int price = 0;
        price = await setPrice('収入', incomeChartData[i].category);
        incomeChartData[i].price = price;
      }
      for (int i = 0; i < spendingChartData.length; i++) {
        int price = 0;
        price = await setPrice('支出', spendingChartData[i].category);
        spendingChartData[i].price = price;
      }

      // percent
      for (int i = 0; i < incomeChartData.length; i++) {
        double percent = 0;
        percent = setPercent(incomeChartData[i].price, incomePrice);
        incomeChartData[i].percent = percent;
      }
      for (int i = 0; i < spendingChartData.length; i++) {
        double percent = 0;
        percent = setPercent(spendingChartData[i].price, spendingPrice);
        spendingChartData[i].percent = percent;
      }

      incomePieData = setPieData(incomeChartData, incomePrice);
      spendingPieData = setPieData(spendingChartData, spendingPrice);
    } else if (categoryDisplay == false) {
      // price
      incomePrice = await setTotalPrice('収入');
      spendingPrice = await setTotalPrice('支出');

      for (int i = 0; i < incomeUserChartData.length; i++) {
        int price = 0;
        price = await setUserPrice('収入', incomeUserChartData[i].category);
        incomeUserChartData[i].price = price;
      }
      for (int i = 0; i < spendingUserChartData.length; i++) {
        int price = 0;
        price = await setUserPrice('支出', spendingUserChartData[i].category);
        spendingUserChartData[i].price = price;
      }

      // percent
      for (int i = 0; i < incomeUserChartData.length; i++) {
        double percent = 0;
        percent = setPercent(incomeUserChartData[i].price, incomePrice);
        incomeUserChartData[i].percent = percent;
      }
      for (int i = 0; i < spendingUserChartData.length; i++) {
        double percent = 0;
        percent = setPercent(spendingUserChartData[i].price, spendingPrice);
        spendingUserChartData[i].percent = percent;
      }

      incomePieData = setPieData(incomeUserChartData, incomePrice);
      spendingPieData = setPieData(spendingUserChartData, spendingPrice);
    }
    notifyListeners();
  }

  List<PieChartSectionData> getIncomeCategory() => incomePieData
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        // const double fontSize = 12;
        const double radius = 50;

        var value = PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: data.title,
          radius: radius,
          titleStyle: const TextStyle(
            // fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        );
        return MapEntry(index, value);
      })
      .values
      .toList();

  List<PieChartSectionData> getSpendingCategory() => spendingPieData
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        // const double fontSize = 12;
        const double radius = 50;

        var value = PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: data.title,
          radius: radius,
          titleStyle: const TextStyle(
            // fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        );
        return MapEntry(index, value);
      })
      .values
      .toList();
}

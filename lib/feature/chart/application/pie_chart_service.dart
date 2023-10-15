import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

// PieChartServiceのプロバイダ
final pieChartServiceProvider = Provider((ref) => PieChartService());

class PieChartService {
  // 対象月の収入 or 支出の合計金額を算出
  int calcTotalPrice({
    required List<Event> events,
    required DateTime date,
    required String largeCategory,
  }) {
    List<int> prices = [];
    final docs = events.where(
      (data) =>
          data.registerDate == DateTime(date.year, date.month) &&
          data.largeCategory == largeCategory,
    );
    if (docs.isEmpty) {
      return 0;
    } else {
      for (final document in docs) {
        final price = document.price;
        prices.add(int.parse(price));
      }
      return prices.reduce((a, b) => a + b);
    }
  }

  // 対象月のカテゴリーごとの金額を算出
  List<int> calcCategoryPrice({
    required List<Event> events,
    required List<Map<String, Object>> categories,
    required DateTime date,
    required String largeCategory,
  }) {
    List<int> prices = [];
    for (int i = 0; i < categories.length; i++) {
      final docs = events.where(
        (data) =>
            data.registerDate == DateTime(date.year, date.month) &&
            data.largeCategory == largeCategory &&
            data.smallCategory == categories[i]['category'],
      );
      if (docs.isEmpty) {
        prices.add(0);
      } else {
        prices.add(0);
        for (final document in docs) {
          prices[i] += int.parse(document.price);
        }
      }
    }
    return prices;
  }

  // 対象月のユーザーごとの金額を算出
  List<int> calcUserPrice({
    required List<Event> events,
    required List<RoomMember> roomMember,
    required DateTime date,
    required String largeCategory,
  }) {
    List<int> prices = [];
    for (int i = 0; i < roomMember.length; i++) {
      final docs = events.where(
        (data) =>
            data.registerDate == DateTime(date.year, date.month) &&
            data.largeCategory == largeCategory &&
            data.paymentUser == roomMember[i].userName,
      );
      if (docs.isEmpty) {
        prices.add(0);
      } else {
        prices.add(0);
        for (final document in docs) {
          prices[i] += int.parse(document.price);
        }
      }
    }
    return prices;
  }

  // 対象月のカテゴリー or ユーザーごとのパーセントの算出
  List<double> calcPercent({
    required int totalPrice,
    required List<int> prices,
  }) {
    List<double> percents = [];
    for (int i = 0; i < prices.length; i++) {
      double percent = 0;
      if (prices[i] != 0) {
        percent = prices[i] / totalPrice * 100;
      } else {
        percent = 0;
      }
      percents.add(percent);
    }
    return percents;
  }

  // 対象月の収支のパーセントの算出
  double calcBpPercent({
    required int smallPrice,
    required int largePrice,
  }) {
    double percent = 0;
    if (smallPrice != 0) {
      percent = smallPrice / largePrice * 100;
    } else {
      percent = 0;
    }
    return percent;
  }

  // 収支円グラフのデータを作成
  List<PieChartSourceData> setBpData({
    required List<Map<String, Object>> categories,
    required List<int> prices,
    required List<double> percents,
  }) {
    List<PieChartSourceData> data = [];
    for (int i = 0; i < categories.length; i++) {
      data.add(
        PieChartSourceData(
          category: categories[i]['category'].toString(),
          icon: null,
          imgURL: null,
          color: categories[i]['color'] as Color,
          price: prices[i],
          percent: percents[i],
        ),
      );
    }
    return data;
  }

  // カテゴリーの円グラフデータを作成
  List<PieChartSourceData> setCategoryData({
    required List<Map<String, Object>> categories,
    required List<int> prices,
    required List<double> percents,
  }) {
    List<PieChartSourceData> data = [];
    for (int i = 0; i < categories.length; i++) {
      data.add(
        PieChartSourceData(
          category: categories[i]['category'].toString(),
          icon: categories[i]['icon'] as IconData,
          imgURL: null,
          color: categories[i]['color'] as Color,
          price: prices[i],
          percent: percents[i],
        ),
      );
    }
    return data;
  }

  // ユーザーの円グラフデータを作成
  List<PieChartSourceData> setUserData({
    required List<RoomMember> roomMember,
    required List<int> prices,
    required List<double> percents,
  }) {
    List<PieChartSourceData> data = [];
    for (int i = 0; i < roomMember.length; i++) {
      data.add(
        PieChartSourceData(
          category: roomMember[i].userName,
          icon: null,
          imgURL: roomMember[i].imgURL,
          color: userColor[i],
          price: prices[i],
          percent: percents[i],
        ),
      );
    }
    return data;
  }

// List<PieChartSectionData>型の値をセット
  List<PieChartSectionData> getCategory({
    required List<PieChartSourceData> pieChartSourceData,
  }) =>
      pieChartSourceData
          .asMap()
          .map<int, PieChartSectionData>((index, data) {
            // const double fontSize = 12;
            // const double radius = 50.w;

            var value = PieChartSectionData(
              color: data.color,
              value: data.percent,
              title: data.category == 'データなし'
                  ? 'データなし'
                  : '${data.category}\n${data.percent.toStringAsFixed(1)}%',
              radius: 50,
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

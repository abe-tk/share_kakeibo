import 'package:share_kakeibo/feature/event/domain/event.dart';

abstract class EventRepository {
  // イベント一覧取得
  Future<List<Event>> readEvent({
    required String roomCode,
  });

  // イベントの作成
  Future<void> createEvent({
    required String roomCode,
    required DateTime date,
    required String price,
    required String largeCategory,
    required String smallCategory,
    required String memo,
    required DateTime currentMonth,
    required String paymentUser,
  });

  // イベントの削除
  Future<void> deleteEvent({
    required String roomCode,
    required String id,
  });

  // イベントの更新
  Future<void> updateEvent({
    required String roomCode,
    required Event event,
    required DateTime date,
    required String price,
    required String smallCategory,
    required String memo,
    required DateTime currentMonth,
    required String paymentUser,
  });
}

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/event/data/event_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

final eventProvider = AsyncNotifierProvider<Events, List<Event>>(Events.new);

class Events extends AsyncNotifier<List<Event>> {
  // refは渡さなくていい

  // ユーザー情報の取得
  Future<List<Event>> readEvent() async {
    final repository = ref.watch(eventRepositoryProvider);
    return repository.readEvent(roomCode: 'JXfnbvqjtURZgDCQHxcOf9OriIo1');
  }

  // 初期データの読み込み
  @override
  FutureOr<List<Event>> build() async {
    return await readEvent();
  }

  // イベントの追加
  Future<void> createEvent({
    required String roomCode,
    required DateTime date,
    required String price,
    required String largeCategory,
    required String smallCategory,
    required String memo,
    required DateTime currentMonth,
    required String paymentUser,
  }) async {
    final repository = ref.watch(eventRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.createEvent(
        roomCode: roomCode,
        date: date,
        price: price,
        largeCategory: largeCategory,
        smallCategory: smallCategory,
        memo: memo,
        currentMonth: currentMonth,
        paymentUser: paymentUser,
      );
      return readEvent();
    });
  }

  // イベントの削除
  Future<void> deleteEvent({
    required String roomCode,
    required String id,
  }) async {
    final repository = ref.watch(eventRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.deleteEvent(
        roomCode: roomCode,
        id: id,
      );
      return readEvent();
    });
  }

  Future<void> updateEvent({
    required String roomCode,
    required Event event,
    required DateTime date,
    required String price,
    required String smallCategory,
    required String memo,
    required DateTime currentMonth,
    required String paymentUser,
  }) async {
    final repository = ref.watch(eventRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.updateEvent(
        roomCode: roomCode,
        event: event,
        date: date,
        price: price,
        smallCategory: smallCategory,
        memo: memo,
        currentMonth: currentMonth,
        paymentUser: paymentUser,
      );
      return readEvent();
    });
  }

}

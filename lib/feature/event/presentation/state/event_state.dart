import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/event/data/event_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

class AsyncEvents extends AsyncNotifier<List<Event>> {
  // イベント一覧の取得
  Future<List<Event>> readEvent() async {
    final repository = ref.watch(eventRepositoryProvider);
    final roomCode = await ref.watch(roomCodeProvider.future);
    return repository.readEvent(roomCode: roomCode);
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

final eventProvider = AsyncNotifierProvider<AsyncEvents, List<Event>>(
  AsyncEvents.new,
);

import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    final events = state.whenOrNull(data: (data) => data) ?? [];

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

      // get処理の回数を減らしたいため、stateにEventを追加
      events.add(
        Event(
          id: '${DateTime.now()}', // 仮のid
          date: date,
          price: price,
          largeCategory: largeCategory,
          smallCategory: smallCategory,
          memo: memo,
          registerDate: currentMonth,
          paymentUser: paymentUser,
        ),
      );
      return events;
    });
  }

  // イベントの削除
  Future<void> deleteEvent({
    required String roomCode,
    required String id,
  }) async {
    final repository = ref.watch(eventRepositoryProvider);
    final events = state.whenOrNull(data: (data) => data) ?? [];

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.deleteEvent(
        roomCode: roomCode,
        id: id,
      );

      // get処理の回数を減らしたいため、stateのEventを削除
      events.removeWhere((element) => element.id == id);
      return events;
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
    final events = state.whenOrNull(data: (data) => data) ?? [];

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

      // get処理の回数を減らしたいため、stateにEventを追加
      final eventList = events
          .map((element) => element.id == event.id
              ? Event(
                  id: event.id,
                  date: date,
                  price: price,
                  largeCategory: event.largeCategory,
                  smallCategory: smallCategory,
                  memo: memo,
                  registerDate: currentMonth,
                  paymentUser: paymentUser,
                )
              : element)
          .toList();
      return eventList;
    });
  }
}

final eventProvider = AsyncNotifierProvider<AsyncEvents, List<Event>>(
  AsyncEvents.new,
);

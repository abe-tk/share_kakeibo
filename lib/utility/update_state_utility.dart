import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

/// イベントの追加やユーザ名の変更時にstateを更新する

// ホーム画面の収支円グラフ、総資産額を更新
void updateHomeState(WidgetRef ref) {
  ref.read(bpPieChartStateProvider.notifier).bpPieChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider));
  ref.read(totalAssetsStateProvider.notifier).calcTotalAssets(ref.read(eventProvider));
}

// カレンダーのイベントを更新
void updateCalendarState(WidgetRef ref) {
  ref.read(calendarEventStateProvider.notifier).fetchCalendarEvent(ref.read(eventProvider));
}

// 統計の円グラフを更新
void updatePieChartState(WidgetRef ref, DateTime date) {
  ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(date, ref.read(eventProvider));
  ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(date, ref.read(eventProvider));
  ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(date, ref.read(eventProvider), ref.read(roomMemberProvider));
  ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(date, ref.read(eventProvider), ref.read(roomMemberProvider));
}

// イベントの追加、編集、削除時にstateを更新
Future<void> updateEventState(WidgetRef ref, DateTime date) async {
  await ref.read(eventProvider.notifier).setEvent();
  updateHomeState(ref);
  updateCalendarState(ref);
  updatePieChartState(ref, date);
}

// イベントのユーザ名に変更時に、stateを更新
Future<void> updateUserNameState(WidgetRef ref, DateTime date) async {
  updatePieChartState(ref, date);
  ref.read(eventProvider.notifier).setEvent();
  ref.read(userProvider.notifier).fetchUser();
  ref.read(roomMemberProvider.notifier).fetchRoomMember();
}

// ユーザのプロフィール画像変更時にstateを更新
void updateUserImgURLState(WidgetRef ref) {
  ref.read(userProvider.notifier).fetchUser();
  ref.read(roomMemberProvider.notifier).fetchRoomMember();
}

/// アプリ起動直後、ルームへの参加、ルームから退出時にstateを更新する

// 各Stateを更新
void updateState(WidgetRef ref) {
  ref.read(roomCodeProvider.notifier).fetchRoomCode();
  ref.read(roomNameProvider.notifier).fetchRoomName();
  ref.read(roomMemberProvider.notifier).fetchRoomMember();
  ref.read(userProvider.notifier).fetchUser();
  ref.read(eventProvider.notifier).setEvent();
  ref.read(memoProvider.notifier).setMemo();
  // Home画面で使用するWidgetの値は、Stateが未取得の状態で計算されてしまうため直接firebaseからデータを読み込む（app起動時のみ）
  ref.read(bpPieChartStateProvider.notifier).bpPieChartFirstCalc(DateTime(DateTime.now().year, DateTime.now().month));
  ref.read(totalAssetsStateProvider.notifier).firstCalcTotalAssets();
}


// firebase
import 'package:share_kakeibo/constant/validation.dart';
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/event_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// state
import 'package:share_kakeibo/state/user/user_state.dart';
import 'package:share_kakeibo/state/room/room_member_state.dart';
import 'package:share_kakeibo/state/event/event_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addEventViewModelProvider =
    StateNotifierProvider<AddEventViewModelNotifier, Map<String, dynamic>>((ref) {
  return AddEventViewModelNotifier();
});

class AddEventViewModelNotifier extends StateNotifier<Map<String, dynamic>> {
  AddEventViewModelNotifier() : super({});

  late String roomCode;
  List<String> paymentUserList = [];
  List<String> incomeCategoryList = [
    '未分類',
    '給与',
    '賞与',
    '臨時収入',
  ];
  List<String> spendingCategoryList = [
    '未分類',
    '食費',
    '外食費',
    '日用雑貨費',
    '交通・車両費',
    '住居費',
    '光熱費(電気)',
    '光熱費(ガス)',
    '水道費',
    '通信費',
    'レジャー費',
    '教育費',
    '医療費',
    'ファッション費',
    '美容費',
  ];

  void setInitialize() {
    state = {
      'date': DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
      'price': '',
      'largeCategory': '',
      'smallCategory': '未分類',
      'memo': '',
      'paymentUser': '',
      'registerDate': DateTime(DateTime.now().year, DateTime.now().month),
    };
  }

  Future fetchPaymentUser() async {
    // 支払い元のユーザを初期値とするため取得
    setInitialize();
    roomCode = await setRoomCodeFire(uid);
    state['paymentUser'] = UserNotifier().state['userName'];
    // 支払い元ユーザのlistを作成
    paymentUserList = [];
    for (int i = 0; i < RoomMemberNotifier().state.length; i++) {
      paymentUserList.add(
          RoomMemberNotifier().state[i].userName
      );
    }
  }

  void setLargeCategory(String largeCategory) {
    state['largeCategory'] = largeCategory;
  }

  void setPrice(String price) {
    state['price'] = price;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2035),
    );
    if (selected != null) {
      state['date'] = selected;
      state['registerDate'] = DateTime(selected.year, selected.month);
    }
  }

  void setSmallCategory(String smallCategory) {
    state['smallCategory'] = smallCategory;
  }

  void setPaymentUser(String paymentUser) {
    state['paymentUser'] = paymentUser;
  }

  void setMemo(String memo) {
    state['memo'] = memo;
  }

  Future<void> addEvent() async {
    addEventValidation(state['price']);
    await addEventFire(
      roomCode,
      state['date'],
      state['price'],
      state['largeCategory'],
      state['smallCategory'],
      state['memo'],
      state['registerDate'],
      state['paymentUser'],
    );
    await EventNotifier().setEvent();
  }

}

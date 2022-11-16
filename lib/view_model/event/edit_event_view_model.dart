import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final editEventViewModelProvider =
StateNotifierProvider<EditEventViewModelNotifier, Map<String, dynamic>>((ref) {
  return EditEventViewModelNotifier();
});

class EditEventViewModelNotifier extends StateNotifier<Map<String, dynamic>> {
  EditEventViewModelNotifier() : super({});

  late Event event;
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

  final priceController = TextEditingController();
  final memoController = TextEditingController();

  void setInitialize(Event event) {
    this.event = event;
    state = {
      'date': event.date,
      'price': event.price,
      'largeCategory': event.largeCategory,
      'smallCategory': event.smallCategory,
      'memo': event.memo,
      'paymentUser': event.paymentUser,
      'registerDate': DateTime(event.date.year, event.date.month),
    };
    priceController.text = event.price;
    memoController.text = event.memo;
  }

  Future fetchPaymentUser(Event event) async {
    setInitialize(event);
    roomCode = await setRoomCodeFire(uid);
    // 支払い元ユーザのlistを作成
    paymentUserList = [];
    for (int i = 0; i < RoomMemberNotifier().state.length; i++) {
      paymentUserList.add(
          RoomMemberNotifier().state[i].userName
      );
    }
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

  Future<void> updateEvent() async {
    addEventValidation(state['price']);
    await updateEventFire(
      roomCode,
      event,
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

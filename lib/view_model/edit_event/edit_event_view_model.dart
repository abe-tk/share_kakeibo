/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// model
import 'package:share_kakeibo/model/event.dart';
import 'package:share_kakeibo/model/room_member.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final editEventViewModel = ChangeNotifierProvider((_) => EditIncomeEventModel());

class EditIncomeEventModel extends ChangeNotifier {

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

  List<String> incomePaymentUserList = [];
  List<String> spendingPaymentUserList = [];

  late String roomCode;
  List<RoomMember> roomMemberList = [];
  List<String> paymentUserList = [];

  late Event event;
  late String price;
  late String memo;
  late DateTime selectedDate;
  late String incomeCategory;
  late String spendingCategory;
  late String incomePaymentUser;
  late String spendingPaymentUser;
  final priceController = TextEditingController();
  final memoController = TextEditingController();

  void setEvent(Event event) {
    this.event = event;
    selectedDate = event.date;
    incomeCategory = event.smallCategory;
    spendingCategory = event.smallCategory;
    price = event.price;
    memo = event.memo;
    incomePaymentUser = event.paymentUser;
    spendingPaymentUser = event.paymentUser;

    priceController.text = event.price;
    memoController.text = event.memo;
  }

  Future <void> fetchPaymentUser() async {
    incomePaymentUserList = await setPaymentUser();
    spendingPaymentUserList = await setPaymentUser();
    notifyListeners();
  }

  Future setPaymentUser() async {
    paymentUserList = [];

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
      paymentUserList.add(
          roomMemberList[i].userName
      );
    }
    return paymentUserList;
  }

  selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF725B51),
            ),
          ),
          child: child!,
        );
      },
    );
    if (selected != null) {
      selectedDate = selected;
    }
    notifyListeners();
  }

  void setIncomeCategory(String incomeCategory) {
    this.incomeCategory = incomeCategory;
    notifyListeners();
  }

  void setSpendingCategory(String spendingCategory) {
    this.spendingCategory = spendingCategory;
    notifyListeners();
  }

  void setIncomePaymentUser(String incomePaymentUser) {
    this.incomePaymentUser = incomePaymentUser;
    notifyListeners();
  }

  void setSpendingPaymentUser(String spendingPaymentUser) {
    this.spendingPaymentUser = spendingPaymentUser;
    notifyListeners();
  }

  void setPrice(String price) {
    this.price = price;
    notifyListeners();
  }

  void setMemo(String memo) {
    this.memo = memo;
    notifyListeners();
  }

  Future <void> incomeEventUpdate() async {

    if (price == null || price == "") {
      throw 'Priceが入力されていません';
    } else if (double.tryParse(price) == null) {
      throw '半角数字のみでご入力ください';
    } else if (price.contains('.')) {
      throw '半角数字のみでご入力ください';
    }

    await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').doc(event.id).update({
      'date': selectedDate,
      'smallCategory': incomeCategory,
      'paymentUser': incomePaymentUser,
      'price': price,
      'memo': memo,
      'registerDate': DateTime(selectedDate.year, selectedDate.month),
    });
  }

  Future <void> spendingEventUpdate() async {

    if (price == null || price == "") {
      throw 'Priceが入力されていません';
    } else if (double.tryParse(price) == null) {
      throw '半角数字のみでご入力ください';
    } else if (price.contains('.')) {
      throw '半角数字のみでご入力ください';
    }

    await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').doc(event.id).update({
      'date': selectedDate,
      'smallCategory': spendingCategory,
      'paymentUser': spendingPaymentUser,
      'price': price,
      'memo': memo,
      'registerDate': DateTime(selectedDate.year, selectedDate.month),
    });
  }

}

/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// model
import 'package:share_kakeibo/model/room_member.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final addEventViewModelProvider = ChangeNotifierProvider((ref) => AddEventViewModel());

class AddEventViewModel extends ChangeNotifier {

  late String roomCode;
  late String name;
  List<RoomMember> roomMemberList = [];
  List<String> paymentUserList = [];

  final DateTime? nowMonth = DateTime(DateTime.now().year, DateTime.now().month);

  final incomeCategoryController = TextEditingController();
  final spendingCategoryController = TextEditingController();
  final incomePaymentUserController = TextEditingController();
  final spendingPaymentUserController = TextEditingController();
  final priceController = TextEditingController();
  final memoController = TextEditingController();

  DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String? incomeCategory = '未分類';
  String? spendingCategory = '未分類';
  late String? incomePaymentUser = name;
  late String? spendingPaymentUser = name;
  String? price;
  String? memo;

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
    name = data?['userName'];

    final memberSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('room')
        .get();
    final roomMembers =
    memberSnapshot.docs.map((snapshot) => RoomMember(snapshot)).toList();
    roomMemberList = roomMembers;

    // paymentUserList.add('未選択');
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
      initialDate: DateTime.now(),
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

  void setSpendingCategory(String? spendingCategory) {
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

  void clearInputData() {
    priceController.clear();
    memoController.clear();
    incomeCategoryController.clear();
    spendingCategoryController.clear();
    incomePaymentUserController.clear();
    spendingPaymentUserController.clear();

    incomeCategory = '未分類';
    spendingCategory = '未分類';
    incomePaymentUser = name;
    spendingPaymentUser = name;
    selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    notifyListeners();
  }

  Future <void> addIncomeEvent() async {
    price = priceController.text;
    memo = memoController.text;

    if (price == null || price == "") {
      throw '金額が入力されていません';
    }

    await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').add({
      'date': selectedDate,
      'price': price,
      'largeCategory': '収入',
      'smallCategory': incomeCategory,
      'memo': memo,
      'registerDate': DateTime(selectedDate.year, selectedDate.month),
      'paymentUser': incomePaymentUser
    });
    notifyListeners();
  }

  Future <void> addSpendingEvent() async {
    price = priceController.text;
    memo = memoController.text;

    if (price == null || price == "") {
      throw 'Priceが入力されていません';
    }

    await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').add({
      'date': selectedDate,
      'price': price,
      'largeCategory': '支出',
      'smallCategory': spendingCategory,
      'memo': memo,
      'registerDate': DateTime(selectedDate.year, selectedDate.month),
      'paymentUser': spendingPaymentUser
    });

    selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    notifyListeners();
  }

}

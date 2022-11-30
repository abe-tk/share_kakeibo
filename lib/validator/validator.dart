import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/impoter.dart';

// イベント追加、編集時
void addEventValidation(price) {
  if (price == null || price == "") {
    throw '金額が入力されていません';
  } else if (double.tryParse(price!) == null) {
    throw '半角数字のみでご入力ください';
  } else if (price!.contains('.')) {
    throw '半角数字のみでご入力ください';
  }
}

// ユーザ名の変更
void updateUserNameValidation(name) {
  if (name == null || name == "") {
    throw 'ユーザ名が入力されていません';
  }
}

// emailの変更
void updateEmailValidation(newEmail, email) {
  if (newEmail == "") {
    throw 'メールアドレスが入力されていません';
  } else if (email == newEmail) {
    throw 'メールアドレスの変更がありません';
  }
}

// passwordの変更
void updatePasswordValidation(password, checkPassword) {
  if (password == '') {
    throw 'パスワードを入力してください';
  } else if (checkPassword == '') {
    throw 'パスワード（確認用）を入力してください';
  } else if (password != checkPassword) {
    throw 'パスワードが一致していません';
  }
}

// パスワード入力
void passwordValidation(password) {
  if (password == null || password == "") {
    throw 'パスワードが入力されていません';
  }
}

// login時
void loginValidation(email, password) {
  if (email == "") {
    throw 'メールアドレスが入力されていません';
  } else if (password == "") {
    throw 'パスワードが入力されていません';
  }
}

// register時
void registerValidation(userName, email, password) {
  if (userName == '') {
    throw 'ユーザー名が入力されていません';
  } else if (email == '') {
    throw 'メールアドレスが入力されていません';
  } else if (password == '') {
    throw 'パスワードが入力されていません';
  }
}

// パスワードリセット
void resetPasswordValidation(String email) {
  if (email == '') {
    throw 'メールアドレスが入力されていません';
  }
}

// ルーム名の変更
void changeRoomNameValidation(newRoomName) {
  if (newRoomName == null || newRoomName == "") {
    throw 'Room名が入力されていません';
  }
}

// ルーム参加時に招待コードの確認
void invitationRoomValidation(roomCode) {
  if (roomCode == null || roomCode == "") {
    throw '招待コードが入力されていません';
  }
}

void exitRoomValidation(String roomCode) {
  if (uid == roomCode) {
    throw 'RoomOwnerは退出できません';
  }
}

// メモの追加
void memoValidation(String memo) {
  if (memo == "") {
    throw 'メモが入力されていません';
  }
}

// FirebaseAuthException
String authValidation(FirebaseAuthException e) {
  switch(e.code) {
    case 'invalid-email':
      return 'メールアドレスが無効です';
    case 'user-not-found':
      return 'ユーザーが存在しません';
    case 'wrong-password':
      return 'パスワードが間違っています';
    case 'weak-password':
      return 'パスワードは6桁以上にしてください';
    case 'email-already-in-use':
      return 'すでに使用されているメールアドレスです';
    default:
      return 'エラー';
  }
}

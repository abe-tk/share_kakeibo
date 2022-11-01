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

// パスワード入力
void passwordValidation(password) {
  if (password == null || password == "") {
    throw 'パスワードが入力されていません';
  }
}

// login時
void loginValidation(email, password) {
  if (email == null || email == "") {
    throw 'メールアドレスが入力されていません';
  } else if (password == null || password == "") {
    throw 'パスワードが入力されていません';
  }
}

// register時
void registerValidation(userName, email, password) {
  if (userName == null || userName == '') {
    throw 'ユーザー名が入力されていません';
  } else if (email == null || email == '') {
    throw 'メールアドレスが入力されていません';
  } else if (password == null || password == '') {
    throw 'パスワードが入力されていません';
  }
}

// ルーム名の変更
void changeRoomNameValidation(newRoomName) {
  if (newRoomName == null || newRoomName == "") {
    throw 'Room名が入力されていません';
  }
}

// ルーム参加時に招待コードの確認
void invitationRoomValidation(roomCode, ownerRoomCode) {
  if (roomCode == null || roomCode == "") {
    throw '招待コードが入力されていません';
  } else if (roomCode != ownerRoomCode || ownerRoomCode == null || ownerRoomCode == '') {
    throw '招待コードが正しくありません';
  }
}
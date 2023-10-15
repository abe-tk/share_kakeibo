class Validator {
  // ユーザ名
  static String? validateUserName({
    required String value,
  }) {
    if (value.isEmpty) {
      return 'ユーザー名をご入力ください';
    }
    return null;
  }

  // メールアドレス
  static String? validateEmail({
    required String value,
  }) {
    if (value.isEmpty) {
      return 'メールアドレスをご入力ください';
    }
    if (!RegExp(r'[\w\-._]+@[\w\-._]+\.[A-Za-z]+').hasMatch(value)) {
      return 'メールアドレスの形式が正しくありません';
    }
    return null;
  }

  // パスワード
  static String? validatePassword({
    required String value,
  }) {
    if (value.isEmpty) {
      return 'パスワードをご入力ください';
    }
    if (value.length < 6 || 20 < value.length) {
      return 'パスワードを6~20文字でご入力ください';
    }
    // if (RegExp(r'^[a-zA-Z0-9!-/:-@[-`{-~]*$').hasMatch(value)) {
    //   return 'パスワードを半角英数字記号のみでご入力ください';
    // }
    return null;
  }

  // イベントの金額
  static String? validatePrice({
    required String value,
  }) {
    if (value.isEmpty) {
      return '金額をご入力ください';
    }
    if (int.tryParse(value) == null) {
      return '金額を半角数字のみでご入力ください';
    }
    if (int.parse(value) <= 0) {
      return '金額を正の整数でご入力ください';
    }
    return null;
  }

  // メモ
  static String? validateMemo({
    required String value,
  }) {
    if (value.isEmpty) {
      return 'メモをご入力ください';
    }
    return null;
  }

  // ルーム名
  static String? validateRoomName({
    required String value,
  }) {
    if (value.isEmpty) {
      return 'ルーム名をご入力ください';
    }
    return null;
  }

  // 招待コード
  static String? validateInvitationCode({
    required String value,
  }) {
    if (value.isEmpty) {
      return '招待コードをご入力ください';
    }
    return null;
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/impoter.dart';

// ユーザーのID
var uid = FirebaseAuth.instance.currentUser!.uid;

// FireAuth関連のメンバ関数
class AuthFire {

  // アカウントへログイン
  Future<void> loginFire(String email, String password) async {
    loginValidation(email, password);
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    // uidをログインしたユーザのIDに変更
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  // アカウントの新規登録
  Future<void> registerFire(String userName, String email, String password) async {
    registerValidation(userName, email, password);
    final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;
    final userID = user?.uid;
    // uidを新規登録したユーザのIDに変更
    uid = userID!;
    // user情報の登録
    UserFire().addUserFire(userName, email, uid);
  }

  // アカウントの削除
  Future<void> deleteAccountFire() async {
    await FirebaseAuth.instance.currentUser!.delete();
  }

  // アカウントのメールアドレス変更、パスワード変更、アカウント削除時にReSingIn
  Future<void> reSingInFire(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }

  // emailを更新
  Future<void> updateEmailFire(String newEmail) async {
    await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
  }

  // passwordを更新
  Future<void> updateUserPasswordFire(String newPassword) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
  }

}




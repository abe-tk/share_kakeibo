// constant
import 'package:share_kakeibo/constant/validation.dart';
import 'package:share_kakeibo/constant/colors.dart';
// view
import 'package:share_kakeibo/view/setting/personal_setting/widgets/change_password_dialog.dart';
// view_model
import 'package:share_kakeibo/view_model/setting/personal_setting/password_view_model.dart';
import 'package:share_kakeibo/view_model/setting/personal_setting/widgets/password_dialog_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasswordPage extends StatefulHookConsumerWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends ConsumerState<PasswordPage> {

  @override
  void initState() {
    super.initState();
    ref.read(passwordViewModelProvider.notifier).setInitialize();
  }

  @override
  Widget build(BuildContext context) {
    final passwordViewModelState = ref.watch(passwordViewModelProvider);
    final passwordViewModelNotifier = ref.watch(passwordViewModelProvider.notifier);
    final _isObscurePassword = useState(true);
    final _isObscureCheckPassword = useState(true);
    final passwordDialogViewModelNotifier = ref.watch(passwordDialogViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'パスワードを変更',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                updatePasswordValidation(passwordViewModelState['password'], passwordViewModelState['checkPassword']);
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ChangePasswordDialog();
                  },
                );
                passwordDialogViewModelNotifier.clearPassword();
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: negativeSnackBarColor,
                  behavior: SnackBarBehavior.floating,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(Icons.check, color: positiveIconColor,),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '変更後のパスワード',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: TextFormField(
                      controller: passwordViewModelNotifier.passwordController,
                      obscureText: _isObscurePassword.value,
                      decoration: InputDecoration(
                        hintText: 'パスワード（6〜20文字）',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            _isObscurePassword.value = !_isObscurePassword.value;
                          },
                        ),
                      ),
                      onChanged: (text) {
                        passwordViewModelNotifier.setPassword(text);
                      },
                      // maxLength: 20,
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '変更後のパスワード（確認用）',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: TextFormField(
                      controller: passwordViewModelNotifier.checkPasswordController,
                      obscureText: _isObscureCheckPassword.value,
                      decoration: InputDecoration(
                        hintText: 'パスワード（6〜20文字）',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscureCheckPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            _isObscureCheckPassword.value = !_isObscureCheckPassword.value;
                          },
                        ),
                      ),
                      onChanged: (text) {
                        passwordViewModelNotifier.setCheckPassword(text);
                      },
                      // maxLength: 20,
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

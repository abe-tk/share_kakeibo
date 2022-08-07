/// view_model
import 'package:share_kakeibo/view_model/setting/mail_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MailPage extends StatefulHookConsumerWidget {
  const MailPage({Key? key}) : super(key: key);

  @override
  _MailPageState createState() => _MailPageState();
}

class _MailPageState extends ConsumerState<MailPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(emailViewModel).fetchEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(emailViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'メールアドレス',
          style: TextStyle(color: Color(0xFF725B51)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF725B51)),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                model.emailValidation();
                showDialog(
                  context: context,
                  builder: (context) {
                    return const PasswordDialog();
                  },
                );
                model.clearPassword();
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: const Icon(Icons.check, color: Colors.green,),
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
                  child: const Text(
                    '現在のメールアドレス',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: Text(model.email ?? ''),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    '変更後のメールアドレス',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                const Divider(),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: TextField(
                      textAlign: TextAlign.left,
                      controller: model.newEmailController,
                      decoration: const InputDecoration(
                        hintText: 'メールアドレス',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        model.setEmail(text);
                      },
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

class PasswordDialog extends HookConsumerWidget {
  const PasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(emailViewModel);
    final _isObscure = useState(true);
    return SimpleDialog(
      title: const Text("パスワードを入力"),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: ListTile(
            title: TextFormField(
              controller: model.passwordController,
              obscureText: _isObscure.value,
              decoration: InputDecoration(
                labelText: 'パスワード',
                suffixIcon: IconButton(
                  icon: Icon(_isObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    _isObscure.value = !_isObscure.value;
                  },
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              onChanged: (text) {
                model.setPassword(text);
              },
              maxLength: 20,
            ),
            // leading: const Icon(Icons.note),
          ),
        ),
        Row(
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
            SimpleDialogOption(
              onPressed: () async {
                try {
                  await model.login();
                  await model.update();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('メールアドレスを変更しました'),
                    ),
                  );
                } catch (e) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar);
                }
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class EmailPage extends StatefulHookConsumerWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends ConsumerState<EmailPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(emailViewModelProvider.notifier).fetchEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailViewModelState = ref.watch(emailViewModelProvider);
    final emailViewModelNotifier = ref.watch(emailViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'メールアドレスを変更',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                updateEmailValidation(emailViewModelState, emailViewModelNotifier.email);
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReSingInDialog(
                      function: () async {
                        await emailViewModelNotifier.updateEmail();
                        await ref.read(userProvider.notifier).fetchUser();
                      },
                      navigator: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      text: 'メールアドレスを変更しました',
                    );
                  },
                );
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
                    '現在のメールアドレス',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: Text(emailViewModelNotifier.email ?? ''),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '変更後のメールアドレス',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: TextField(
                      textAlign: TextAlign.left,
                      controller: emailViewModelNotifier.emailController,
                      decoration: const InputDecoration(
                        hintText: 'メールアドレス',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        emailViewModelNotifier.setEmail(text);
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

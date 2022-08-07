/// view_model
import 'package:share_kakeibo/view_model/chart/chart_view_model.dart';
import 'package:share_kakeibo/view_model/setting/profile_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends StatefulHookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(profileViewModel).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(profileViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'プロフィール',
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
                await ref.read(profileViewModel).update();
                ref.read(chartViewModelProvider).calc();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('プロフィールを編集しました'),
                  ),
                );
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: const Icon(
              Icons.check,
              color: Colors.green,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'プロフィール画像',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
            GestureDetector(
              child: SizedBox(
                width: 150,
                height: 150,
                child: model.imgFile == null
                    ? Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(65, 65, 65, 0.1),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(model.imgURL ??
                                'https://kotonohaworks.com/free-icons/wp-content/uploads/kkrn_icon_user_11.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(65, 65, 65, 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.file(
                          model.imgFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              onTap: () async {
                await model.pickImg();
                model.setNewImgURL(model.newImgURL ??
                    'https://kotonohaworks.com/free-icons/wp-content/uploads/kkrn_icon_user_11.png');
              },
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: const Text(
                'ユーザ名',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                title:TextField(
                  textAlign: TextAlign.left,
                  controller: model.nameController,
                  decoration: const InputDecoration(
                    hintText: 'ユーザ名を入力してください',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    model.setName(text);
                  },
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

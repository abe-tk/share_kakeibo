import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class DetailEventPage extends StatefulHookConsumerWidget {
  const DetailEventPage({Key? key}) : super(key: key);

  @override
  _DetailEventPageState createState() => _DetailEventPageState();
}

class _DetailEventPageState extends ConsumerState<DetailEventPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(detailEventStateProvider.notifier).fetchDetailEvent(ref.read(eventProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailEventState = ref.watch(detailEventStateProvider);
    return Scaffold(
      appBar: const CustomAppBar(title: '過去の明細'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: detailEventState.length,
            itemBuilder: (context, index) {
              if (detailEventState.isEmpty) {
                return const NoDataCaseImg(text: '取引', height: 36);
              }
              return DetailEventList(
                price: detailEventState[index].price,
                largeCategory: detailEventState[index].largeCategory,
                smallCategory: detailEventState[index].smallCategory,
                paymentUser: detailEventState[index].paymentUser,
                memo: detailEventState[index].memo,
                date: detailEventState[index].date,
                function: () {
                  ref.read(paymentUserProvider.notifier).fetchPaymentUser(ref.read(roomMemberProvider));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return EditEventPage(event: detailEventState[index]);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

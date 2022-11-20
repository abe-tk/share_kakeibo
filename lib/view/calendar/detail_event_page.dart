import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
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
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(detailEventViewModelProvider.notifier).fetchDetailEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailEventState = ref.watch(detailEventViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('過去の明細'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBarBackGroundColor,
        bottom: PreferredSize(
          child: Container(
            height: 0.1,
            color: appBarBottomLineColor,
          ),
          preferredSize: const Size.fromHeight(0.1),
        ),
      ),
      body: SafeArea(
        child: (detailEventState.isNotEmpty)
            ? ListView.builder(
                itemCount: detailEventState.length,
                itemBuilder: (context, index) {
                  return AppDetailList(
                    price: detailEventState[index].price,
                    largeCategory: detailEventState[index].largeCategory,
                    smallCategory: detailEventState[index].smallCategory,
                    paymentUser: detailEventState[index].paymentUser,
                    memo: detailEventState[index].memo,
                    date: detailEventState[index].date,
                    function: () {
                      ref.read(paymentUserProvider.notifier).fetchPaymentUser();
                      Navigator.push(
                        context,
                        PageTransition(
                          child: EditEventPage(event: detailEventState[index]),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 150),
                          reverseDuration: const Duration(milliseconds: 150),
                        ),
                      );
                    },
                  );
                },
              )
            : const NoDataCase(text: '取引'),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:share_kakeibo/impoter.dart';
//
// class AppToggleButton extends StatefulHookConsumerWidget {
//    late bool value;
//    AppToggleButton({
//     Key? key,
//     required this.value,
//   }) : super(key: key);
//
//   // final bool boo; //上位Widgetから受け取りたいデータ
//   // AppToggleButton({required this.boo}); //コンストラクタ
//
//   @override
//   _AppToggleButtonState createState() => _AppToggleButtonState();
// }
//
// class _AppToggleButtonState extends ConsumerState<AppToggleButton> {
//
//   @override
//   Widget build(BuildContext context) {
//     final isSelected = useState(<bool>[true, false]);
//     // final isDisplay = useState(true);
//     return ToggleButtons(
//       fillColor: toggleFillColor,
//       borderWidth: 2,
//       borderColor: toggleBorder,
//       selectedColor: toggleSelectedColor,
//       selectedBorderColor: toggleSelectedBorder,
//       borderRadius: BorderRadius.circular(10),
//       children: const [
//         Padding(
//           padding: EdgeInsets.all(4.0),
//           child: Text('カテゴリ'),
//         ),
//         Padding(
//           padding: EdgeInsets.all(4.0),
//           child: Text('支払い元'),
//         ),
//       ],
//       isSelected: isSelected.value,
//       onPressed: (index) {
//         setState(() {
//           for (int buttonIndex = 0;
//           buttonIndex < isSelected.value.length;
//           buttonIndex++) {
//             if (buttonIndex == index) {
//               isSelected.value[buttonIndex] = true;
//             } else {
//               isSelected.value[buttonIndex] = false;
//             }
//           }
//         });
//         switch (index) {
//           case 0:
//             widget.value = true;
//             break;
//           case 1:
//             widget.value = false;
//             break;
//         }
//       },
//     );
//   }
// }

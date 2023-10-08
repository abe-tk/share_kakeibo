import 'package:flutter/material.dart';

class UpsertEventItem extends StatelessWidget {
  final Icon icon;

  // TextField
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool autofocus;
  final Function(String)? textChange;

  // selectDate
  final String? date;
  final Function()? selectDate;

  // DropDownButton
  final String? initialItem;
  final List<String>? items;
  final Function(String?)? selectItem;

  const UpsertEventItem({
    Key? key,
    required this.icon,

    // TextField
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.none,
    this.autofocus = false,
    this.textChange,

    // selectDate
    this.date,
    this.selectDate,

    // DropDownButton
    this.initialItem,
    this.items,
    this.selectItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: icon,
          ),

          // TextField
          if (controller != null)
            Expanded(
              child: TextField(
                autofocus: autofocus,
                keyboardType: keyboardType,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: textChange,
              ),
            ),

          // selectDate
          if (date != null)
            Expanded(
              child: GestureDetector(
                child: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.white,
                  height: 48,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      date!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: selectDate,
              ),
            ),

          // DropDownButton
          if (items != null)
            Expanded(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: DropdownButton<String>(
                    value: initialItem,
                    iconSize: 0,
                    underline: const SizedBox.shrink(),
                    onChanged: selectItem,
                    items: items!.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

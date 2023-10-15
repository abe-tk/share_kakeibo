import 'package:flutter/material.dart';

class UpsertEventDropDownButton extends StatelessWidget {
  final Icon icon;
  final String? initialItem;
  final List<String>? items;
  final Function(String?)? selectItem;

  const UpsertEventDropDownButton({
    Key? key,
    required this.icon,
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

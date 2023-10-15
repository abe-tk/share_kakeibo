import 'package:flutter/material.dart';

class UpsertEventSelectData extends StatelessWidget {
  final Icon icon;
  final String? date;
  final Function()? selectDate;

  const UpsertEventSelectData({
    Key? key,
    required this.icon,
    this.date,
    this.selectDate,
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
        ],
      ),
    );
  }
}

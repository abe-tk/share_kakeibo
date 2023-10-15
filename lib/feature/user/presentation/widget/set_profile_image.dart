import 'dart:io';

import 'package:flutter/material.dart';

class SetProfileImage extends StatelessWidget {
  final String imgURL;
  final String imgFilePath;
  final Function function;
  const SetProfileImage({
    Key? key,
    required this.imgURL,
    required this.imgFilePath,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: GestureDetector(
        child: SizedBox(
          width: 150,
          height: 150,
          child: imgFilePath == ''
              ? Container(
                  width: 150,
                  height: 150,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(65, 65, 65, 0.1),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imgURL),
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
                    File(imgFilePath),
                    fit: BoxFit.cover,
                  ),
                ),
        ),
        onTap: () {
          function();
        },
      ),
    );
  }
}

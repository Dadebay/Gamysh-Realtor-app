// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/constants/constants.dart';

class MyButton extends StatelessWidget {
  final String name;
  final Function() onTap;

  const MyButton({this.name, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey[300])),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  maxLines: 2,
                  style: const TextStyle(
                    fontFamily: robotoRegular,
                    fontSize: 16,
                  )),
              const Icon(
                IconlyLight.arrowRightCircle,
                color: Colors.black,
              )
            ],
          )),
    );
  }
}

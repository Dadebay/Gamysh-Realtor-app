// ignore_for_file: file_names, avoid_implementing_value_types

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/constants/constants.dart';
import 'package:get/get.dart';

class MyAppBar extends StatelessWidget implements PreferredSize {
  const MyAppBar({
    Key key,
    this.name,
    this.widget,
    this.backArrow,
  }) : super(key: key);

  final bool backArrow;
  final String name;
  final Widget widget;
  @override
  Widget get child => const Text("Error");

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        elevation: 0.0,
        centerTitle: true,
        leading: backArrow
            ? IconButton(
                icon: const Icon(IconlyLight.arrowLeft, color: Colors.black),
                onPressed: () {
                  Get.back();
                },
              )
            : const SizedBox.shrink(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Center(child: widget),
          )
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          name.tr,
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: robotoMedium),
        ),
      ),
    );
  }
}

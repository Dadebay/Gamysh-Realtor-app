// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamys/constants/constants.dart';
import 'package:get/get.dart';

class ConnectionError extends StatelessWidget {
  final String buttonText;
  final Function() onTap;

  const ConnectionError({Key key, this.buttonText, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: Get.size.width,
            transform: Matrix4.translationValues(30, 0, 0),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(bottom: 35),
            child: SvgPicture.asset(
              "assets/icons/svgIcons/404.svg",
              height: Get.size.height * 0.28,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
            child: Text(
              "noConnection1".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: robotoMedium,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
            child: Text(
              "error404".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: robotoRegular,
                fontSize: 18,
              ),
            ),
          ),
          if (buttonText == "")
            const SizedBox.shrink()
          else
            RaisedButton(
              onPressed: onTap,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: kPrimaryColor,
              child: Text(
                buttonText.tr ?? "l",
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: robotoMedium, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

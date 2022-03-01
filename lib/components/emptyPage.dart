// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gamys/constants/constants.dart';
import 'package:get/get.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key key, this.image, this.text, this.onTap, this.buttonText, this.subtitle}) : super(key: key);

  final Function() onTap;
  final String buttonText;
  final String image;
  final String subtitle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: SvgPicture.asset(
            image ?? "",
            fit: BoxFit.fill,
            width: Get.size.width,
            height: Get.size.height * 0.30,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: subtitle == "" ? 15 : 10, left: 10, top: subtitle == "" ? 25 : 15),
          child: Text(
            text.tr ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: robotoMedium,
              fontSize: 20,
            ),
          ),
        ),
        if (subtitle != "")
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              left: 10,
            ),
            child: Text(
              subtitle.tr ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: robotoRegular,
                fontSize: 18,
              ),
            ),
          )
        else
          buttonText != ""
              ? RaisedButton(
                  onPressed: onTap,
                  color: kPrimaryColor,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    buttonText.tr,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: robotoMedium, fontWeight: FontWeight.w600),
                  ),
                )
              : const SizedBox.shrink(),
      ],
    );
  }
}

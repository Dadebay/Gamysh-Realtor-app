// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:get/get.dart';

class EmailTextField extends StatelessWidget {
  EmailTextField({
    Key key,
    this.mineFocus,
    this.requestFocus,
    this.controller,
  }) : super(key: key);

  final AuthController authController = Get.put(AuthController());
  final TextEditingController controller;
  final FocusNode mineFocus;
  final FocusNode requestFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontFamily: robotoMedium, fontSize: 17, color: Colors.white),
      textInputAction: TextInputAction.next,
      focusNode: mineFocus,
      controller: controller,
      validator: controller.text.isEmpty
          ? null
          : (value) {
              if (value.length < 3) {
                return "errorGmailName".tr;
              }
              // if (!GetUtils.isEmail(value)) {
              //   return "errorGmailName1".tr;
              // }
              else {
                return null;
              }
            },
      onEditingComplete: () {
        requestFocus.requestFocus();
      },
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontFamily: robotoRegular),
        contentPadding: const EdgeInsets.only(left: 5),
        labelText: "email".tr,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: robotoMedium),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:get/get.dart';

class TextFieldMine extends StatelessWidget {
  TextFieldMine({
    Key key,
    this.mineFocus,
    this.requestFocus,
    this.controller,
    this.hintText,
  }) : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final AuthController loginController = Get.put(AuthController());
  final FocusNode mineFocus;
  final FocusNode requestFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontFamily: robotoMedium, fontSize: 17, color: Colors.white),
      textInputAction: TextInputAction.next,
      focusNode: mineFocus,
      controller: controller,
      validator: (value) {
        if (value.length < 3) {
          return "errorLengthName".tr;
        }
        return null;
      },
      onEditingComplete: () {
        requestFocus.requestFocus();
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(60),
      ],
      cursorColor: kPrimaryColor,
      decoration: InputDecoration(
        errorMaxLines: 3,
        errorStyle: const TextStyle(fontFamily: robotoRegular),
        contentPadding: const EdgeInsets.only(left: 5),
        labelText: hintText.tr,
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

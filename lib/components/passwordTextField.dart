// ignore_for_file: file_names, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:get/get.dart';

class PasswordTextFieldMine extends StatelessWidget {
  PasswordTextFieldMine({
    Key key,
    this.mineFocus,
    this.requestFocus,
    this.controller,
    this.hintText,
  }) : super(key: key);

  final AuthController authController = Get.put(AuthController());
  final TextEditingController controller;
  final String hintText;
  final FocusNode mineFocus;
  final FocusNode requestFocus;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextFormField(
        style: const TextStyle(fontFamily: robotoMedium, fontSize: 17, color: Colors.white),
        textInputAction: TextInputAction.next,
        focusNode: mineFocus,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[0-9 a-z A-Z]')),
          LengthLimitingTextInputFormatter(14),
        ],
        controller: controller,
        validator: (value) {
          final RegExp regexSan = RegExp('[0-9]');
          if (value.isEmpty) {
            return "errorPassword1".tr;
          } else if (value.length < 8) {
            return 'errorPassword2'.tr;
          } else {
            if (!regexSan.hasMatch(value)) {
              return 'errorPassword3'.tr;
            } else {
              return null; //"errorPassword0".tr;
            }
          }
        },
        onEditingComplete: () {
          mineFocus.requestFocus();
        },
        cursorColor: kPrimaryColor,
        obscureText: authController.signInObscure.value,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
              onTap: () {
                authController.changeSignInObscure();
              },
              child: Icon(
                authController.signInObscure.value ? Icons.visibility_off : Icons.visibility,
                color: authController.signInObscure.value ? Colors.grey : kPrimaryColor,
              )),
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
    });
  }
}

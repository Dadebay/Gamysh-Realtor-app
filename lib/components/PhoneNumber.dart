// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamys/constants/constants.dart';
import 'package:get/get.dart';

class PhoneNumber extends StatelessWidget {
  const PhoneNumber({
    Key key,
    this.mineFocus,
    this.controller,
    this.requestFocus,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode mineFocus;
  final FocusNode requestFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontFamily: robotoMedium, fontSize: 18, color: Colors.white),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      focusNode: mineFocus,
      controller: controller,
      validator: (value) {
        if (value.length < 8) {
          return "errorPhoneNumber".tr;
        }
        return null;
      },
      inputFormatters: [
        LengthLimitingTextInputFormatter(8),
      ],
      onEditingComplete: () {
        requestFocus.requestFocus();
      },
      cursorColor: kPrimaryColor,
      decoration: const InputDecoration(
        errorMaxLines: 3,
        errorStyle: TextStyle(fontFamily: robotoRegular),
        contentPadding: EdgeInsets.zero,
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: 5,
          ),
          child: Text(
            '+ 993  ',
            style: TextStyle(color: Colors.white, fontSize: 18, fontFamily: robotoMedium),
          ),
        ),
        prefixIconConstraints: BoxConstraints(),
        hintText: '__ ______',
        hintStyle: TextStyle(color: Colors.white, fontSize: 18, fontFamily: robotoMedium),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

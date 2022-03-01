// ignore_for_file: require_trailing_commas, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamys/components/agreeButton.dart';
import 'package:gamys/components/passwordTextField.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/models/UserModels/UserSignInModel.dart';
import 'package:gamys/views/BottomNavBar/BottomNavBar.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
// // import 'package:vibration/vibration.dart';

class ChangePassword extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  TextEditingController newPassword = TextEditingController();
  TextEditingController smsCode = TextEditingController();
  TextEditingController verifyPassword = TextEditingController();

  final GlobalKey<FormState> _form1Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SizedBox(
            height: Get.size.height,
            child: Stack(
              children: [
                backgroundImage(),
                Positioned.fill(
                  child: Container(
                    height: Get.size.height / 2,
                    decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12.withOpacity(0.1), blurRadius: 15.0, offset: const Offset(0.0, 0.75))], color: Colors.black54.withOpacity(0.5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "signIn1".tr,
                                  style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 24),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "signIn2".tr,
                                  style: const TextStyle(color: Colors.white, fontFamily: robotoRegular, fontSize: 20),
                                ),
                              ],
                            ),
                            Form(
                              key: _form1Key,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextFormField(
                                    validator: (value) => value.isEmpty ? "errorSMSCode".tr : null,
                                    style: const TextStyle(fontFamily: robotoMedium, fontSize: 17, color: Colors.white),
                                    textAlign: TextAlign.left,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: smsCode,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    onEditingComplete: () {
                                      focusNode2.requestFocus();
                                    },
                                    cursorColor: kPrimaryColor,
                                    decoration: InputDecoration(
                                      errorMaxLines: 3,
                                      labelText: "getSMS".tr,
                                      errorStyle: const TextStyle(fontFamily: robotoRegular),
                                      contentPadding: const EdgeInsets.only(left: 5),
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
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 60),
                                    child: PasswordTextFieldMine(
                                      mineFocus: focusNode2,
                                      requestFocus: focusNode3,
                                      controller: newPassword,
                                      hintText: "newPassword",
                                    ),
                                  ),
                                  PasswordTextFieldMine(
                                    mineFocus: focusNode3,
                                    requestFocus: focusNode3,
                                    controller: verifyPassword,
                                    hintText: "verifyPassword",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: AgreeButton(
                            name: "agree".tr,
                            color: Colors.white,
                            textColor: kPrimaryColor,
                            onTap: () {
                              if (newPassword.text == verifyPassword.text) {
                                if (_form1Key.currentState.validate()) {
                                  authController.signInAnimation.value = true;
                                  UserSignInModel()
                                      .changePassword(
                                    code: smsCode.text,
                                    newPassword: verifyPassword.text,
                                  )
                                      .then((value) {
                                    if (value != null) {
                                      Get.to(() => BottomNavBar()).then((value) {
                                        newPassword.clear();
                                        verifyPassword.clear();
                                      });
                                      authController.signInAnimation.value = false;
                                    } else {
                                      authController.signInAnimation.value = false;
                                      newPassword.clear();
                                      verifyPassword.clear();
                                      Vibration.vibrate();
                                      _form1Key.currentState.validate();
                                    }
                                  });
                                } else {
                                  Vibration.vibrate();
                                }
                              } else {
                                authController.signInAnimation.value = false;
                                newPassword.clear();
                                verifyPassword.clear();
                                Vibration.vibrate();
                                _form1Key.currentState.validate();
                              }
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

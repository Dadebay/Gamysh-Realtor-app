// ignore_for_file: require_trailing_commas, file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/components/PhoneNumber.dart';
import 'package:gamys/components/agreeButton.dart';
import 'package:gamys/components/passwordTextField.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/models/UserModels/UserSignInModel.dart';
import 'package:gamys/views/BottomNavBar/BottomNavBar.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import 'ForgotPasswordPage.dart';
import 'SmsAuthPage.dart';

class LoginInPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  TextEditingController passwordContoller = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _form1Key = GlobalKey();

  Column textPart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20, top: 30),
          child: Text(
            "login".tr,
            style: const TextStyle(color: Colors.white, fontFamily: robotoBold, fontSize: 24),
          ),
        ),
        Text(
          "signIn2".tr,
          style: const TextStyle(color: Colors.white, fontFamily: robotoRegular, fontSize: 20),
        ),
      ],
    );
  }

  Column bottomButtons() {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      AgreeButton(
          name: "agree",
          color: Colors.white,
          textColor: kPrimaryColor,
          onTap: () {
            if (_form1Key.currentState.validate()) {
              authController.signInAnimation.value = true;
              UserSignInModel()
                  .login(
                phone: phoneController.text,
                password: passwordContoller.text,
              )
                  .then((value) {
                if (value == "home") {
                  Get.to(() => BottomNavBar());
                  authController.signInAnimation.value = false;
                } else if (value == "smsgit") {
                  Get.to(() => SmsAuth(
                        whichPage: 0,
                        phoneNumber: phoneController.text,
                      ));

                  authController.signInAnimation.value = false;
                } else {
                  authController.signInAnimation.value = false;
                  phoneController.clear();
                  passwordContoller.clear();
                  _form1Key.currentState.validate();
                }
              });
            } else {
              phoneController.clear();
              passwordContoller.clear();
              Vibration.vibrate();
            }
          }),
      TextButton(
        onPressed: () {
          Get.to(() => ForgotPage());
        },
        child: Text(
          "forgotpassword".tr,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: robotoMedium,
            fontSize: 16,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ]);
  }

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
                Positioned(
                    top: 30,
                    left: 10,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(IconlyLight.arrowLeft, color: Colors.white, size: 35))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: Form(
                          key: _form1Key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              textPart(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 45),
                                child: PhoneNumber(
                                  mineFocus: focusNode3,
                                  requestFocus: focusNode4,
                                  controller: phoneController,
                                ),
                              ),
                              PasswordTextFieldMine(
                                mineFocus: focusNode4,
                                requestFocus: focusNode4,
                                controller: passwordContoller,
                                hintText: "password",
                              ),
                            ],
                          ),
                        ),
                      ),
                      bottomButtons()
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

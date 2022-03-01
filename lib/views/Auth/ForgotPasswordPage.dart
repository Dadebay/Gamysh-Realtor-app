// ignore_for_file: require_trailing_commas, must_be_immutable, file_names

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/components/PhoneNumber.dart';
import 'package:gamys/components/agreeButton.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/models/UserModels/UserSignInModel.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import 'ChangePassword.dart';

class ForgotPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  FocusNode focusNode4 = FocusNode();
  TextEditingController phoneController = TextEditingController();

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
                        boxShadow: <BoxShadow>[BoxShadow(color: Colors.black12.withOpacity(0.2), blurRadius: 15.0, offset: const Offset(0.0, 0.75))], color: Colors.black54.withOpacity(0.5)),
                  ),
                ),
                Positioned(
                    top: 50,
                    left: 10,
                    child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(IconlyLight.arrowLeft, color: Colors.white, size: 35))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30, right: 20),
                              child: Text(
                                "forgotpassword".tr,
                                style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 24),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                "forgotPasswordTitle".tr,
                                style: const TextStyle(color: Colors.white, fontFamily: robotoRegular, fontSize: 20),
                              ),
                            ),
                            Form(
                              key: _form1Key,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: PhoneNumber(
                                  mineFocus: focusNode4,
                                  // requestFocus: focusNode4,
                                  controller: phoneController,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AgreeButton(
                          name: "agree",
                          color: Colors.white,
                          textColor: kPrimaryColor,
                          onTap: () {
                            if (_form1Key.currentState.validate()) {
                              authController.signInAnimation.value = true;
                              UserSignInModel()
                                  .forgotPassword(
                                phoneNumber: phoneController.text,
                              )
                                  .then((value) {
                                if (value == 404) {
                                  Get.snackbar("", "",
                                      titleText: const Text(
                                        "Ulanyjy yok",
                                        style: TextStyle(color: kPrimaryColor, fontSize: 16, fontFamily: robotoMedium),
                                      ),
                                      messageText: const Text(
                                        "Hormatly müşderi siz ulgamda ulgama giriň.",
                                        style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: robotoRegular),
                                      ),
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.white,
                                      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20));

                                  authController.signInAnimation.value = false;
                                } else if (value == 200) {
                                  Get.to(() => ChangePassword());
                                  authController.signInAnimation.value = false;
                                } else {
                                  authController.signInAnimation.value = false;
                                  phoneController.clear();
                                  _form1Key.currentState.validate();
                                }
                              });
                            } else {
                              Vibration.vibrate();
                            }
                          })
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

// ignore_for_file: file_names, must_be_immutable, require_trailing_commas

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/components/agreeButton.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/models/UserModels/UserSignInModel.dart';
import 'package:gamys/views/BottomNavBar/BottomNavBar.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import 'ChangePassword.dart';

class SmsAuth extends StatelessWidget {
  SmsAuth({Key key, this.phoneNumber, @required this.whichPage}) : super(key: key);

  final AuthController authController = Get.put(AuthController());
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());
  TextEditingController codeController = TextEditingController();
  final String phoneNumber;
  final int whichPage;

  final GlobalKey<FormState> _form1Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              height: Get.size.height,
              child: Stack(
                children: [
                  backgroundImage(),
                  Positioned.fill(
                    child: Container(
                      height: Get.size.height,
                      decoration: BoxDecoration(boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.2),
                          blurRadius: 15.0,
                        )
                      ], color: Colors.black54.withOpacity(0.5)),
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
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "otpVerfication".tr,
                                style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 24),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 30),
                                child: Text(
                                  "smsSend".tr,
                                  style: const TextStyle(color: Colors.white, fontFamily: robotoRegular, fontSize: 20),
                                ),
                              ),
                              Text(
                                "+993 $phoneNumber",
                                textAlign: TextAlign.center,
                                style: const TextStyle(height: 1, fontFamily: robotoMedium, color: Colors.white, fontSize: 22),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
                                child: Form(
                                  key: _form1Key,
                                  child: TextFormField(
                                    validator: (value) => value.isEmpty ? "errorSMSCode".tr : null,
                                    style: const TextStyle(fontFamily: robotoMedium, fontSize: 20, color: Colors.white),
                                    textAlign: TextAlign.left,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    controller: codeController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(6),
                                    ],
                                    cursorColor: kPrimaryColor,
                                    decoration: InputDecoration(
                                        label: Text(
                                          "getSMS".tr,
                                          style: const TextStyle(fontFamily: robotoRegular, fontSize: 18, color: Colors.white),
                                        ),
                                        contentPadding: const EdgeInsets.only(left: 20, bottom: 15, top: 15),
                                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2), borderRadius: borderRadius10),
                                        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red[500], width: 2), borderRadius: borderRadius10),
                                        focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2), borderRadius: borderRadius10),
                                        border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2), borderRadius: borderRadius10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AgreeButton(
                                name: "agree",
                                color: Colors.white,
                                textColor: kPrimaryColor,
                                onTap: () {
                                  if (_form1Key.currentState.validate()) {
                                    authController.signInAnimation.value = true;
                                    UserSignInModel().otpVerfication(code: codeController.text).then((value) {
                                      if (value != null) {
                                        if (whichPage == 0) {
                                          bottomNavBarController.selectedPageIndex.value = 0;
                                        }
                                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => whichPage == 0 ? BottomNavBar() : ChangePassword()));
                                        Future.delayed(const Duration(milliseconds: 200), () {
                                          authController.signInAnimation.value = false;
                                          codeController.clear();
                                        });
                                      } else {
                                        authController.signInAnimation.value = false;
                                        codeController.clear();
                                        _form1Key.currentState.validate();
                                      }
                                    });
                                  } else {
                                    Vibration.vibrate();
                                  }
                                }),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

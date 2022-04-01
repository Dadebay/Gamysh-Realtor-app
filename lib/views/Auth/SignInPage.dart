// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, require_trailing_commas, deprecated_member_use, type_annotate_public_apis

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamys/components/EmailTextField.dart';
import 'package:gamys/components/PhoneNumber.dart';
import 'package:gamys/components/TextFieldMine.dart';
import 'package:gamys/components/agreeButton.dart';
import 'package:gamys/components/passwordTextField.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/models/UserModels/UserSignInModel.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';

import 'LoginPage.dart';
import 'SmsAuthPage.dart';

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController phoneController = TextEditingController();
TextEditingController passwordController = TextEditingController();
FocusNode focusNode1 = FocusNode();
FocusNode focusNode2 = FocusNode();
FocusNode focusNode3 = FocusNode();
FocusNode focusNode4 = FocusNode();
final GlobalKey<FormState> _form1Key = GlobalKey();

class SignInPage extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  Obx changeRealtor() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RaisedButton(
            onPressed: () {
              authController.changeRealtor();
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: authController.realtor.value ? kPrimaryColor : Colors.white, width: 2)),
            child: Text(
              "iamRealtor".tr,
              style: const TextStyle(color: Colors.black, fontFamily: robotoMedium),
            ),
          ),
          RaisedButton(
            onPressed: () {
              authController.changeRealtor();
            },
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: borderRadius5, side: BorderSide(color: authController.realtor.value ? Colors.white : kPrimaryColor, width: 2)),
            child: Text(
              "iamOwner".tr,
              style: const TextStyle(color: Colors.black, fontFamily: robotoMedium),
            ),
          ),
        ],
      );
    });
  }

  AgreeButton signInButton() {
    return AgreeButton(
        name: "agree".tr,
        color: Colors.white,
        textColor: kPrimaryColor,
        onTap: () {
          if (_form1Key.currentState.validate()) {
            authController.signInAnimation.value = true;

            UserSignInModel()
                .signUp(
                    fullname: nameController.text,
                    phoneNumber: phoneController.text,
                    password: passwordController.text,
                    email: emailController.text,
                    realtor: authController.realtor.value == false ? 1 : 2)
                .then((value) {
              if (value == 400 || value == 405) {
                phoneController.clear();
                passwordController.clear();
                _form1Key.currentState.validate();
                Vibration.vibrate();

                showSnackBar("errorSnapshot", "errorLogin400", Colors.red);
              } else if (value == 500) {
                Vibration.vibrate();

                showSnackBar("errorSnapshot", "errorLogin500", Colors.red);
              } else if (value == 409) {
                phoneController.clear();
                userIsActive();

                _form1Key.currentState.validate();
                Vibration.vibrate();
              } else if (value == 200) {
                Get.to(() => SmsAuth(
                      whichPage: 0,
                      phoneNumber: phoneController.text,
                    ));
                Future.delayed(const Duration(milliseconds: 200), () {
                  authController.signInAnimation.value = false;
                  authController.signInObscure.value = false;
                  nameController.clear();
                  emailController.clear();
                  phoneController.clear();
                  passwordController.clear();
                });
              }
              authController.signInAnimation.value = false;
            });
          } else {
            Vibration.vibrate();
          }
        });
  }

  TextButton loginButton() {
    return TextButton(
      onPressed: () {
        Get.to(() => LoginInPage());
        _form1Key.currentState.reset();
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        passwordController.clear();
        authController.signInObscure.value = true;
        authController.signInAnimation.value = false;
      },
      child: Text(
        "login".tr,
        style: const TextStyle(
          color: Colors.white,
          fontFamily: robotoMedium,
          fontSize: 16,
          //letterSpacing: 2.0,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  // ignore: always_declare_return_types
  userIsActive() {
    authController.signInAnimation.value = false;
    Get.snackbar("", "",
        titleText: Text(
          "userIsActiveTitle".tr,
          style: const TextStyle(color: kPrimaryColor, fontSize: 16, fontFamily: robotoMedium),
        ),
        messageText: Text(
          "userIsActiveSubtitle".tr,
          style: const TextStyle(color: Colors.black, fontSize: 14, fontFamily: robotoRegular),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.white,
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20));
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
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
                    decoration: BoxDecoration(boxShadow: <BoxShadow>[BoxShadow(color: Colors.grey.withOpacity(0.1), offset: const Offset(0.0, 0.75))], color: Colors.black54.withOpacity(0.5)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      textPart(
                        "signIn1",
                        "signIn2",
                      ),
                      Expanded(
                        flex: 2,
                        child: Form(
                          key: _form1Key,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFieldMine(
                                mineFocus: focusNode1,
                                requestFocus: focusNode2,
                                controller: nameController,
                                hintText: "name",
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: EmailTextField(
                                  mineFocus: focusNode2,
                                  requestFocus: focusNode3,
                                  controller: emailController,
                                ),
                              ),
                              PhoneNumber(
                                requestFocus: focusNode4,
                                mineFocus: focusNode3,
                                controller: phoneController,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: PasswordTextFieldMine(
                                  mineFocus: focusNode4,
                                  requestFocus: focusNode4,
                                  controller: passwordController,
                                  hintText: "password",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      changeRealtor(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            signInButton(),
                            loginButton(),
                          ],
                        ),
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

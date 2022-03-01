// ignore_for_file: file_names, missing_return, type_annotate_public_apis, always_declare_return_types, non_constant_identifier_names, require_trailing_commas, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/controllers/ProfilPageController.dart';
import 'package:gamys/controllers/UpdateRealEstateController.dart';
import 'package:gamys/views/Auth/SignInPage.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';

import '../UpdateRealEstate/MyRealEstates.dart';
import 'Components/Profile_Widgets.dart';
import 'HistoryView.dart';

class ProfilePage extends StatelessWidget {
  final ProfilePageController profilePageController = Get.put(ProfilePageController());
  final AuthController authController = Get.put(AuthController());
  final UpdateReaLEstateController updateReaLEstateController = Get.put(UpdateReaLEstateController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profilePageController.token.value == "")
                  const SizedBox.shrink()
                else
                  const SizedBox(
                    height: 20,
                  ),
                if (profilePageController.token.value == "")
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 30),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "loginSubtitle".tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: robotoRegular, fontSize: 16, color: Colors.black),
                          ),
                        ),
                        SizedBox(
                            width: Get.size.width,
                            child: RaisedButton(
                                onPressed: () {
                                  authController.signInAnimation.value = false;
                                  Get.to(() => SignInPage());
                                },
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                disabledElevation: 0,
                                color: kPrimaryColor,
                                child: Text(
                                  "loginButtonName".tr,
                                  style: const TextStyle(fontFamily: robotoMedium, fontSize: 16, color: Colors.white),
                                )))
                      ],
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (profilePageController.token.value == "") const SizedBox.shrink() else titleText("profil1"),
                if (profilePageController.token.value == "")
                  const SizedBox.shrink()
                else
                  buttonProfile(
                    name: "my_real_estates",
                    icon: CupertinoIcons.home,
                    buttonBackColor: Colors.blue,
                    onTap: () {
                      updateReaLEstateController.refreshPage();

                      Get.to(() => MyRealEstates());
                    },
                  ),
                if (profilePageController.token.value == "")
                  const SizedBox.shrink()
                else
                  const SizedBox(
                    height: 20,
                  ),
                titleText("settings1"),
                langSelect(),
                buttonProfile(
                  name: "historyView",
                  icon: Icons.history,
                  buttonBackColor: Colors.grey,
                  onTap: () {
                    Get.to(() => HistoryView());
                  },
                ),
                if (profilePageController.token.value == "")
                  const SizedBox.shrink()
                else
                  buttonProfile(
                    name: "deleteAccount",
                    icon: IconlyLight.delete,
                    buttonBackColor: Colors.green,
                    onTap: () {
                      deleteAccount();
                    },
                  ),

                // buttonProfile(
                //   name: "clearCache",
                //   icon: IconlyLight.delete,
                //   buttonBackColor: Colors.green,
                //   onTap: () async {
                //     clearCache();
                //   },
                // ),
                buttonProfile(
                  name: "share",
                  icon: Icons.share,
                  buttonBackColor: kPrimaryColor,
                  onTap: () {
                    Share.share('https://play.google.com/store/apps/details?id=com.bilermennesil.gamysh', subject: 'Gamyş');
                  },
                ),
                buttonProfile(
                  name: "termsAndCondition",
                  icon: IconlyLight.document,
                  buttonBackColor: Colors.blue,
                  onTap: () {
                    termsAndConditionWidget();
                  },
                ),
                buttonProfile(
                  name: "Versiya 1.6",
                  icon: IconlyLight.infoSquare,
                  buttonBackColor: kPrimaryColor,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ));
  }

  AppBar appBar() {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () {
            if (profilePageController.token.value != "") {
              logOut();
            } else {
              authController.signInAnimation.value = false;
              Get.to(() => SignInPage());
            }
          },
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                profilePageController.token.value != "" ? "log_out".tr : "login".tr,
                style: const TextStyle(color: kPrimaryColor, fontSize: 16, fontFamily: robotoMedium),
              ),
            ),
          ),
        ),
      ],
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Text(
        "profil".tr,
        maxLines: 1,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: robotoMedium),
      ),
    );
  }
}

// ignore_for_file: missing_return, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_restart/flutter_restart.dart';
// import 'package:flutter_restart/flutter_restart.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/controllers/ProfilPageController.dart';
import 'package:gamys/models/UserModels/AuthModel.dart';
import 'package:gamys/views/Auth/connection_check.dart';
import 'package:get/get.dart';

final ProfilePageController profilePageController = Get.put(ProfilePageController());

Future<dynamic> logOut() {
  Get.bottomSheet(Container(
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "log_out".tr,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark, size: 30, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text("log_out_title".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: robotoMedium,
                fontSize: 16,
              )),
        ),
        GestureDetector(
          onTap: () async {
            await Auth().logout();
            await Auth().removeToken();
            await Auth().removeRefreshToken();
            profilePageController.token.value = "";
            Get.to(() => ConnectionCheck());
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius10),
            child: Text(
              "log_out_yes".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: robotoBold, fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius10),
            child: Text(
              "no".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  ));
}

Future<dynamic> deleteAccount() {
  final AuthController authController = Get.put(AuthController());

  Get.bottomSheet(Container(
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "deleteAccount".tr,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark, size: 30, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text("deleteAccountSubtitle".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: robotoMedium,
                fontSize: 16,
              )),
        ),
        GestureDetector(
          onTap: () async {
            print("${authController.userId.value}");
            await Auth().deleteUser().then((value) async {
              if (value == true) {
                await Auth().logout();
                await Auth().removeToken();
                await Auth().removeRefreshToken();
                profilePageController.token.value = "";
                Get.to(() => ConnectionCheck());
              } else {
                showSnackBar("retry", "error404", Colors.red);
              }
            });
            // Get.to(() => ConnectionCheck());
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius10),
            child: Text(
              "log_out_yes".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: robotoBold, fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius10),
            child: Text(
              "no".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  ));
}

Future<dynamic> clearCache() {
  Get.bottomSheet(Container(
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "clearAppCache".tr,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark, size: 30, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Text("clearAppCacheSubtitle".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
                fontFamily: robotoMedium,
                fontSize: 16,
              )),
        ),
        GestureDetector(
          onTap: () async {
            // final result = await FlutterRestart.restartApp();
            // await FlutterRestart.restartApp();
            Get.to(() => ConnectionCheck());
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.red, borderRadius: borderRadius10),
            child: Text(
              "yes".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontFamily: robotoBold, fontSize: 16),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            Get.back();
          },
          child: Container(
            width: Get.size.width,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: borderRadius10),
            child: Text(
              "no".tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
            ),
          ),
        ),
      ],
    ),
  ));
}

Text titleText(String name) {
  return Text(
    name.tr,
    maxLines: 1,
    textAlign: TextAlign.left,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: robotoMedium),
  );
}

Future termsAndConditionWidget() {
  return Get.bottomSheet(
    Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  "termsAndCondition".tr,
                  style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(CupertinoIcons.xmark, size: 22, color: Colors.black),
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey[200],
            height: 1,
            thickness: 2,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  "termsAndConditionSubtitile".tr,
                  textAlign: TextAlign.start,
                  style: const TextStyle(fontFamily: robotoRegular, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: false,
  );
}

ListTile langSelect() {
  return ListTile(
    tileColor: Colors.white,
    focusColor: Colors.white,
    hoverColor: Colors.white,
    selectedTileColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 10),
    onTap: () {
      changeLanguage();
    },
    leading: CircleAvatar(
      backgroundImage: AssetImage(
        Get.locale.languageCode == "en" ? 'assets/icons/pngIcons/tm.png' : 'assets/icons/pngIcons/ru.png',
      ),
      radius: 17,
    ),
    title: Text(
      "language".tr,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.black, fontSize: 18, fontFamily: robotoRegular),
    ),
    trailing: const Icon(
      IconlyLight.arrowRightCircle,
      color: Colors.black,
      size: 20,
    ),
  );
}

Future<dynamic> changeLanguage() {
  Get.bottomSheet(Container(
    padding: const EdgeInsets.only(bottom: 20),
    decoration: const BoxDecoration(color: Colors.white),
    child: Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Text(
                "select_language".tr,
                style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.xmark, size: 22, color: Colors.black),
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        const SizedBox(
          height: 20,
        ),
        ListTile(
            onTap: () async {
              Get.updateLocale(const Locale('en'));
              saveData("en");
              final result = await FlutterRestart.restartApp();
              print(result);
              Get.back();
            },
            leading: const CircleAvatar(
              backgroundImage: AssetImage(
                turkmenIcon,
              ),
              backgroundColor: Colors.white,
              radius: 20,
            ),
            title: const Text(
              "Türkmen",
              style: TextStyle(fontFamily: robotoMedium),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListTile(
              onTap: () async {
                Get.updateLocale(const Locale('ru'));
                saveData("ru");
                final result = await FlutterRestart.restartApp();
                print(result);
                Get.back();
              },
              leading: const CircleAvatar(
                backgroundImage: AssetImage(
                  russianIcon,
                ),
                radius: 20,
                backgroundColor: Colors.white,
              ),
              title: const Text(
                "Русский",
                style: TextStyle(fontFamily: robotoMedium),
              )),
        ),
      ],
    ),
  ));
}

// ignore_for_file: deprecated_member_use, duplicate_ignore, implementation_imports, avoid_positional_boolean_parameters, require_trailing_commas, missing_return

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

Future<String> languageCode() async {
  if (Get.locale.languageCode != null) {
    if (Get.locale.languageCode == "en") {
      return lang = "tm";
    } else if (Get.locale.languageCode == "ru") {
      return lang = "ru";
    }
  } else {
    return lang = "ru";
  }
}

SnackbarController showSnackBar(
  String title,
  String subtitle,
  Color color,
) {
  return Get.snackbar(title, subtitle,
      titleText: Text(
        title.tr,
        style: const TextStyle(fontFamily: robotoMedium, fontSize: 16, color: Colors.white),
      ),
      messageText: Text(
        subtitle.tr,
        style: const TextStyle(fontFamily: robotoRegular, fontSize: 14, color: Colors.white),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20));
}

ListTile rightArrowButton(String name, Function() onTap) {
  return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      onTap: onTap,
      dense: true,
      title: Text(
        name.tr,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: robotoRegular,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(IconlyLight.arrowRight2, size: 20, color: Colors.black));
}

Future<bool> saveData(String value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setString("language", value);
}

Future<String> loadData() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString("language");
}

Future<bool> loadDataFirstTime() async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getBool("firstTime");
}

Future<bool> firsttimeSaveData(bool value) async {
  final SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.setBool("firstTime", value);
}

Widget noImage() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/svgIcons/logo.svg",
          color: Colors.grey[500],
          width: 140,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "noImage".tr,
          style: const TextStyle(color: Colors.black, fontFamily: robotoMedium),
        )
      ],
    ),
  );
}

CustomFooter loadMore() {
  Text myText(String name) {
    return Text(name.tr,
        maxLines: 2,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.black,
          fontFamily: robotoMedium,
        ));
  }

  return CustomFooter(
    builder: (BuildContext context, LoadStatus mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = myText("scrollTop");
      } else if (mode == LoadStatus.loading) {
        body = const CupertinoActivityIndicator(
          radius: 15,
        );
      } else if (mode == LoadStatus.failed) {
        body = myText("retry");
      } else if (mode == LoadStatus.canLoading) {
        body = const Icon(
          IconlyBroken.arrowDown,
          color: Colors.black,
          size: 35,
        );
      } else {
        body = myText("retry");
      }
      return SizedBox(
        height: 55.0,
        child: Center(child: body),
      );
    },
  );
}

Widget dividerr() {
  return Container(
    color: Colors.grey[300],
    width: double.infinity,
    height: 1,
  );
}

Widget spinKit() {
  return const SpinKitWave(
    color: kPrimaryColor,
    size: 40,
  );
}

Widget errorData(String errorName, String buttonText, Function() onTap) {
  return Center(
      child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            errorName.tr,
            maxLines: 2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: robotoMedium,
              fontSize: 16,
            ),
          ),
        ),
        if (buttonText == "")
          const SizedBox.shrink()
        else
          RaisedButton(
            onPressed: onTap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: kPrimaryColor,
            child: Text(
              buttonText.tr ?? "l",
              style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: robotoMedium, fontWeight: FontWeight.w600),
            ),
          )
      ],
    ),
  ));
}

Widget buttonProfile({String name, IconData icon, Function() onTap, Color buttonBackColor}) {
  return ListTile(
    tileColor: Colors.white,
    focusColor: Colors.white,
    hoverColor: Colors.white,
    selectedTileColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 10),
    onTap: onTap,
    leading: Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(color: buttonBackColor, borderRadius: borderRadius10),
      child: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
    ),
    title: Text(
      name.tr,
      maxLines: 1,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.black, fontSize: 16, fontFamily: robotoRegular),
    ),
    trailing: const Icon(
      IconlyLight.arrowRightCircle,
      color: Colors.black,
      size: 18,
    ),
  );
}

Expanded textPart(String name1, String name2) {
  return Expanded(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          name1.tr,
          style: const TextStyle(color: Colors.white, fontFamily: robotoMedium, fontSize: 24),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          name2.tr,
          style: const TextStyle(color: Colors.white, fontFamily: robotoRegular, fontSize: 20),
        ),
      ],
    ),
  );
}

Image backgroundImage() => Image.asset("assets/images/city2.png", height: Get.size.height, fit: BoxFit.cover);
SvgPicture backgroundImageSVG() => SvgPicture.asset("assets/images/city2.svg", height: Get.size.height, fit: BoxFit.cover);

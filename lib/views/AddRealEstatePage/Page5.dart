// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/views/BottomNavBar/BottomNavBar.dart';
import 'package:get/get.dart';

class Page5 extends StatelessWidget {
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          backgroundImage(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: SvgPicture.asset(
                      "assets/icons/svgIcons/File_uploaded.svg",
                      fit: BoxFit.fill,
                      height: MediaQuery.of(context).size.height * 0.30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
                    child: Text(
                      "addedRealEstates".tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: robotoMedium,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Get.to(() => BottomNavBar());
                      bottomNavBarController.selectedPageIndex.value = 0;
                    },
                    shape: const RoundedRectangleBorder(borderRadius: borderRadius10),
                    color: kPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "next".tr,
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontFamily: robotoMedium, fontWeight: FontWeight.w600),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(IconlyLight.arrowRightCircle, color: Colors.white, size: 24),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

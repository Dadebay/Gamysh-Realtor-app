// ignore_for_file: file_names, require_trailing_commas, deprecated_member_use, must_be_immutable, invalid_use_of_protected_member, always_declare_return_types, type_annotate_public_apis

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/views/AddRealEstatePage/Page3.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'Page1.dart';
import 'Page2.dart';
import 'Page4.dart';
import 'Page5.dart';

class AddRealEstatePage extends StatefulWidget {
  @override
  _AddRealEstatePageState createState() => _AddRealEstatePageState();
}

class _AddRealEstatePageState extends State<AddRealEstatePage> {
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

  List page = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
  ];

  Widget progressIndicator() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (bottomNavBarController.selectedPageIndex.value > 0) {
                    bottomNavBarController.dicrementPageIndex();
                  } else {
                    Get.back();
                  }
                },
                child: bottomNavBarController.selectedPageIndex.value == 4
                    ? const SizedBox.shrink()
                    : const Icon(
                        IconlyLight.arrowLeftCircle,
                        color: kPrimaryColor,
                        size: 25,
                      ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  bottomNavBarController.selectedPageIndex.value = 0;
                },
                child: Text(
                  "close".tr,
                  style: const TextStyle(color: kPrimaryColor, fontFamily: robotoMedium),
                ),
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: StepProgressIndicator(
            totalSteps: page.length,
            currentStep: bottomNavBarController.selectedPageIndex.value + 1,
            size: 8,
            customStep: (index, color, size) {
              return Container(
                width: 25,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(borderRadius: borderRadius5, color: color),
              );
            },
            selectedColor: kPrimaryColor,
            unselectedColor: Colors.grey[200],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: backgroundColor,
            body: Obx(() {
              return Column(
                children: [progressIndicator(), Expanded(child: page[bottomNavBarController.selectedPageIndex.value] as Widget)],
              );
            })));
  }
}

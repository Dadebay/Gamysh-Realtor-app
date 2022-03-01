// ignore_for_file: missing_return, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:gamys/views/AddRealEstatePage/AddRealEstatePage.dart';
import 'package:get/get.dart';

@override
final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

Future emlakGosmak2() {
  Get.bottomSheet(Container(
    margin: const EdgeInsets.all(15),
    padding: const EdgeInsets.all(15),
    decoration: const BoxDecoration(
      borderRadius: borderRadius5,
      color: Colors.white,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "addRealEstateDialog1".tr,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: robotoMedium,
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(CupertinoIcons.xmark_circle_fill),
                color: Colors.grey,
                onPressed: () {
                  Get.back();
                },
              )
            ],
          ),
        ),
        Divider(
          color: Colors.grey[200],
          height: 1,
          thickness: 2,
        ),
        rightArrowButton("sell", () {
          bottomNavBarController.selectedCategoryId(1);
          Get.back();
          emlakGosmak3();
        }),
        dividerr(),
        rightArrowButton("rent", () {
          bottomNavBarController.selectedCategoryId(2);
          Get.back();
          emlakGosmak3();
        }),
      ],
    ),
  ));
}

Future emlakGosmak3() {
  Get.bottomSheet(
    Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: borderRadius5,
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "addRealEstateDialog2".tr,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: robotoMedium,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark_circle_fill),
                  color: Colors.grey,
                  onPressed: () {
                    Get.back();
                  },
                )
              ],
            ),
          ),
          Divider(
            color: Colors.grey[200],
            height: 1,
            thickness: 2,
          ),
          rightArrowButton("sell1", () {
            bottomNavBarController.selectedMainId(1);
            Get.back();
            emlakGosmak4();
          }),
          dividerr(),
          rightArrowButton("sell2", () {
            bottomNavBarController.selectedMainId(2);
            Get.back();
            emlakGosmak4();
          }),
        ],
      ),
    ),
  );
}

Future emlakGosmak4() {
  Get.bottomSheet(Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: borderRadius5,
        color: Colors.white,
      ),
      child: Column(
        // alignment: WrapAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "addRealEstateDialog1".tr,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: robotoMedium,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark_circle_fill),
                  color: Colors.grey,
                  onPressed: () {
                    Get.back();
                  },
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
            child: Obx(() {
              return FutureBuilder<List<RealEstateTypes>>(
                  future: RealEstateTypes().getTypes(categoryId: bottomNavBarController.categoryId.value, typeId: bottomNavBarController.mainId.value),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return errorData("error404", "retry", () {
                        Get.back();
                      });
                    } else if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: spinKit(),
                      ));
                    } else if (snapshot.data.isEmpty) {
                      return errorData("error", "retry", () {});
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            rightArrowButton(snapshot.data[index].name, () {
                              bottomNavBarController.selectedPageIndex.value = 0;
                              bottomNavBarController.selectedTypeID(snapshot.data[index].id);
                              Get.back();
                              Get.to(() => AddRealEstatePage());
                            }),
                            dividerr()
                          ],
                        );
                      },
                    );
                  });
            }),
          ),
        ],
      )));
}

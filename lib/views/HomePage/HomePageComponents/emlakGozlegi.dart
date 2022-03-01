// ignore_for_file: file_names, deprecated_member_use, camel_case_types, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/controllers/FilterController.dart';
import 'package:get/get.dart';

import '../FilterPage/filterPages.dart';

class emlakGozlegi extends StatelessWidget {
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

  List<IconData> icons = [Icons.vpn_key, Icons.king_bed_sharp, CupertinoIcons.building_2_fill, Icons.home];
  List<String> names = [
    'searchHouse1'.tr,
    'searchHouse2'.tr,
    'searchHouse3'.tr,
    'searchHouse4'.tr,
  ];
  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: GridView.builder(
        itemCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 9 / 4),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400.withOpacity(0.4),
                blurRadius: 2,
                spreadRadius: 2,
              )
            ]),
            child: RaisedButton(
              splashColor: Colors.grey[200],
              disabledColor: Colors.white,
              color: Colors.white,
              disabledElevation: 0,
              elevation: 0,
              onPressed: () {
                filterController.choiceChipList.clear();
                filterController.specListMine.clear();
                if (index == 0) {
                  bottomNavBarController.selectedCategoryId(1);
                  filterController.tabbarIndex.value = 0;
                  filterController.typeId.value = 3;
                  Get.to(() => FilterPages(), transition: Transition.fadeIn);
                } else if (index == 1) {
                  bottomNavBarController.selectedCategoryId(2);
                  filterController.tabbarIndex.value = 0;
                  Get.to(() => FilterPages(), transition: Transition.fadeIn);
                } else if (index == 2) {
                  filterController.tabbarIndex.value = 1;
                  Get.to(() => FilterPages(), transition: Transition.fadeIn);
                } else {
                  Get.to(() => FilterPages(), transition: Transition.fadeIn);
                }
              },
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 5),
              child: SizedBox(
                width: Get.size.width,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(icons[index], size: 30, color: kPrimaryColor),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          names[index],
                          maxLines: 1,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

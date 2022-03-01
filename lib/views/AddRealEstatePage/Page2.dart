// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/components/myButton.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AddRealEstateController.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:get/get.dart';

class Page2 extends StatelessWidget {
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());
  final AddRealEstateController addRealEstateController = Get.put(AddRealEstateController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          width: Get.size.width,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Text(
            "selectTown".tr,
            style: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: SizedBox(
          width: Get.size.width,
          child: FutureBuilder<List<Region>>(
              future: Region().getRegion(
                index: bottomNavBarController.mainLocationBig.value,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinKit());
                } else if (snapshot.hasError) {
                  return ConnectionError(
                      buttonText: "",
                      onTap: () {
                        Get.back();
                        bottomNavBarController.selectedPageIndex.value = 0;
                      });
                } else if (snapshot.data.isEmpty) {
                  return EmptyPage(
                    image: "assets/icons/svgIcons/File_cracked.svg",
                    text: "error",
                    subtitle: "",
                    buttonText: "retry",
                    onTap: () {
                      Get.back();
                      bottomNavBarController.selectedPageIndex.value = 0;
                    },
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MyButton(
                        name: snapshot.data[index].name,
                        onTap: () {
                          addRealEstateController.textFieldShadowBool.value = false;
                          bottomNavBarController.incrementPageIndex();
                          bottomNavBarController.mainLocationMini.value = snapshot.data[index].id;
                        });
                  },
                );
              }),
        )),
      ],
    );
  }
}

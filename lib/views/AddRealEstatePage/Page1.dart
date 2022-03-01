// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/components/myButton.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/models/AddRealEstateModel.dart';
import 'package:get/get.dart';

class Page1 extends StatelessWidget {
  final BottomNavBarController bottomNavBarController = Get.put(BottomNavBarController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.white,
          width: Get.size.width,
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Text(
            "selectCity".tr,
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
              future: Region().getMainLocations(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ConnectionError(
                      buttonText: "",
                      onTap: () {
                        Get.back();
                        bottomNavBarController.selectedPageIndex.value = 0;
                      });
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: spinKit());
                } else if (snapshot.data == null) {
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
                          bottomNavBarController.incrementPageIndex();
                          bottomNavBarController.mainLocationBig.value = snapshot.data[index].id;
                        });
                  },
                );
              }),
        )),
      ],
    );
  }
}

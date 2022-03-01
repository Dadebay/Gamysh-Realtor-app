// ignore_for_file: must_be_immutable, require_trailing_commas, file_names, always_declare_return_types, type_annotate_public_apis, camel_case_types

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/BottomNavBarController.dart';
import 'package:gamys/controllers/FilterController.dart';
import 'package:gamys/models/GetLocation.dart';
import 'package:get/get.dart';

class SelectRegion extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  final BottomNavBarController locationController = Get.put(BottomNavBarController());
  final FilterController filterController = Get.put(FilterController());

  selectRegion2() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("selectRegion".tr,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: robotoBold,
                      )),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(CupertinoIcons.xmark, color: Colors.black)),
                ],
              ),
            ),
            dividerr(),
            dividerr(),
            FutureBuilder(
                future: GetLocationModel().getNames(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      child: spinKit(),
                    ));
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 35),
                      child: Text("errorQuickSearch".tr, style: const TextStyle(color: Colors.black, fontFamily: robotoMedium, fontSize: 18)),
                    ));
                  } else if (snapshot.data == null) {
                    return Expanded(
                        child: Center(
                      child: EmptyPage(
                        image: "assets/icons/svgIcons/File_cracked.svg",
                        text: "error",
                        subtitle: "",
                        buttonText: "retry",
                        onTap: () {
                          Get.back();
                        },
                      ),
                    ));
                  }
                  return Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          locationController.changeName(snapshot.data[index].locationName);
                          filterController.changegetLocationID(snapshot.data[index].id);

                          Get.back();
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          child: Text(
                            snapshot.data[index].locationName,
                            style: const TextStyle(fontFamily: robotoMedium, fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ));
                })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      child: Obx(() {
        return GestureDetector(
          onTap: () {
            selectRegion2();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("  ${locationController.locationName}", style: const TextStyle(color: Colors.black, fontFamily: robotoBold, fontSize: 16)),
              const SizedBox(width: 5),
              const Icon(Icons.arrow_drop_down_outlined, color: Colors.black)
            ],
          ),
        );
      }),
    );
  }
}

// ignore_for_file: file_names, require_trailing_commas, noop_primitive_operations

import 'package:flutter/material.dart';
import 'package:gamys/components/RealEstateCard2.dart';
import 'package:gamys/components/appBar.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/UpdateRealEstateController.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyRealEstates extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();

  final UpdateReaLEstateController updateReaLEstateController = Get.put(UpdateReaLEstateController());

  void _onRefresh() {
    updateReaLEstateController.refreshPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    updateReaLEstateController.addPage();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        backArrow: true,
        name: "my_real_estates",
      ),
      body: SmartRefresher(
        enablePullUp: true,
        physics: const BouncingScrollPhysics(),
        primary: true,
        header: const MaterialClassicHeader(
          color: kPrimaryColor,
        ),
        footer: loadMore(),
        controller: _refreshController,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: Obx(() {
          if (updateReaLEstateController.loading.value == 0) {
            return Center(child: spinKit());
          } else if (updateReaLEstateController.loading.value == 1) {
            return Center(
              child: EmptyPage(
                image: "assets/icons/svgIcons/EmptyPageIcon.svg",
                text: "noAddedHousesTitle",
                subtitle: "noAddedHousesSubtitle",
                buttonText: "",
                onTap: () {},
              ),
            );
          }

          return GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: updateReaLEstateController.list.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 1 : 2, mainAxisSpacing: 15),
              itemBuilder: (BuildContext context, int index) {
                return RealEstateCard2(
                  id: updateReaLEstateController.list[index]["id"],
                  images: updateReaLEstateController.list[index]["images"],
                  location: updateReaLEstateController.list[index]["location"] ?? "Aşgabat",
                  name: updateReaLEstateController.list[index]["name"] ?? "Gamyş",
                  phone: "",
                  price: updateReaLEstateController.list[index]["price"] ?? "0",
                  // ignore: avoid_bool_literals_in_conditional_expressions
                  likedValue: updateReaLEstateController.list[index]["wishList"] == null
                      ? false
                      // ignore: avoid_bool_literals_in_conditional_expressions
                      : updateReaLEstateController.list[index]["wishList"] == 0
                          ? false
                          : true,
                  addedRealEstate_Widget: true,
                  addedRealEstate_Text: updateReaLEstateController.list[index]["statusID"] == 2
                      ? "2"
                      : updateReaLEstateController.list[index]["statusID"] == 4
                          ? "4"
                          : updateReaLEstateController.list[index]["isActive"] == null
                              ? "null"
                              : updateReaLEstateController.list[index]["isActive"] == true
                                  ? "true"
                                  : "false",
                );
              });
        }),
      ),
    );
  }
}

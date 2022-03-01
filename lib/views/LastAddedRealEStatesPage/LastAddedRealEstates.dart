// ignore_for_file: file_names, require_trailing_commas, avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';
import 'package:gamys/components/RealEstateCard2.dart';
import 'package:gamys/components/appBar.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/RealEstatesController.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LastAddedRealEstatesPage extends StatelessWidget {
  final RealEstatesController getRealEstates = Get.put(RealEstatesController());

  final RefreshController _refreshController = RefreshController();

  void _onRefresh() {
    getRealEstates.refreshPage();
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    getRealEstates.addPage();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: const MyAppBar(
              name: "lastAdded",
              backArrow: false,
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
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: Obx(() {
                  if (getRealEstates.loading.value == 1) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: getRealEstates.list.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 1 : 2, mainAxisSpacing: 15, childAspectRatio: 9 / 11),
                            itemBuilder: (BuildContext context, int index) {
                              return RealEstateCard2(
                                addedRealEstate_Widget: false,
                                name: getRealEstates.list[index]["name"] as String,
                                price: getRealEstates.list[index]["price"].toString(),
                                id: getRealEstates.list[index]["id"] as int,
                                location: getRealEstates.list[index]["location"] as String,
                                phone: getRealEstates.list[index]["phone"] as String,
                                vip: getRealEstates.list[index]["vip"] == 1 ? true : false,
                                images: getRealEstates.list[index]["images"] as List,
                                likedValue: getRealEstates.list[index]["wishList"] == null
                                    ? false
                                    : getRealEstates.list[index]["wishList"] == 0
                                        ? false
                                        : true,
                              );
                            }));
                  } else if (getRealEstates.loading.value == 2) {
                    return Center(
                      child: EmptyPage(
                        image: "assets/icons/svgIcons/EmptyPageIcon.svg",
                        text: "emptyRealEstates",
                        subtitle: "",
                        buttonText: "",
                        onTap: () {},
                      ),
                    );
                  } else if (getRealEstates.loading.value == 3) {
                    return Center(
                      child: ConnectionError(
                          buttonText: "",
                          onTap: () {
                            getRealEstates.fetchRealEstates();
                          }),
                    );
                  }

                  return Center(
                    child: spinKit(),
                  );
                }))));
  }
}

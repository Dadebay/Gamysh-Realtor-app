// ignore_for_file: file_names, avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';
import 'package:gamys/components/RealEstateCard2.dart';
import 'package:gamys/components/appBar.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/GetUserOtherRealEstates.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GetAllRealEstates extends StatefulWidget {
  final int id;
  GetAllRealEstates({Key key, this.id}) : super(key: key);

  @override
  State<GetAllRealEstates> createState() => _GetAllRealEstatesState();
}

class _GetAllRealEstatesState extends State<GetAllRealEstates> {
  @override
  void initState() {
    if (getUserOtherRealEstatesController.list.length > 0) {
    } else {
      getUserOtherRealEstatesController.fetchRealEstates(widget.id);
    }
    super.initState();
  }

  final RefreshController _refreshController = RefreshController();

  final GetUserOtherRealEstates getUserOtherRealEstatesController = Get.put(GetUserOtherRealEstates());

  void _onRefresh() {
    _refreshController.refreshCompleted();
    getUserOtherRealEstatesController.refresh();
  }

  void _onLoading() {
    _refreshController.loadComplete();

    getUserOtherRealEstatesController.addPage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: MyAppBar(
          name: "userRealEstates",
          backArrow: true,
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
          child: Obx(
            () {
              if (getUserOtherRealEstatesController.loading.value == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: getUserOtherRealEstatesController.list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 1 : 2, mainAxisSpacing: 15, childAspectRatio: 9 / 11),
                    itemBuilder: (BuildContext context, int index) {
                      return RealEstateCard2(
                        addedRealEstate_Widget: false,
                        ownerId: getUserOtherRealEstatesController.list[index]["ownerID"],
                        name: getUserOtherRealEstatesController.list[index]["name"],
                        price: getUserOtherRealEstatesController.list[index]["price"],
                        id: getUserOtherRealEstatesController.list[index]["id"],
                        location: getUserOtherRealEstatesController.list[index]["location"],
                        phone: getUserOtherRealEstatesController.list[index]["phone"],
                        vip: getUserOtherRealEstatesController.list[index]["vip"] == 1 ? true : false,
                        images: getUserOtherRealEstatesController.list[index]["images"] as List,
                        likedValue: getUserOtherRealEstatesController.list[index]["wishList"] == null
                            ? false
                            : getUserOtherRealEstatesController.list[index]["wishList"] == 0
                                ? false
                                : true,
                      );
                    },
                  ),
                );
              } else if (getUserOtherRealEstatesController.loading.value == 2) {
                return Center(
                  child: EmptyPage(
                    image: "assets/icons/svgIcons/EmptyPageIcon.svg",
                    text: "noAddedHousesTitle",
                    subtitle: "",
                    buttonText: "",
                    onTap: () {},
                  ),
                );
              } else if (getUserOtherRealEstatesController.loading.value == 3) {
                return Center(
                  child: ConnectionError(
                      buttonText: "",
                      onTap: () {
                        getUserOtherRealEstatesController.fetchRealEstates(widget.id);
                      }),
                );
              }

              return Center(
                child: spinKit(),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: file_names, prefer_typing_uninitialized_variables, type_annotate_public_apis, require_trailing_commas, noop_primitive_operations, deprecated_member_use, avoid_bool_literals_in_conditional_expressions

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:gamys/components/RealEstateCard2.dart';
import 'package:gamys/components/emptyPage.dart';
import 'package:gamys/components/errorConnection.dart';
import 'package:gamys/constants/constants.dart';
import 'package:gamys/constants/widgets.dart';
import 'package:gamys/controllers/AuthController.dart';
import 'package:gamys/controllers/FilterController.dart';
import 'package:gamys/views/HomePage/FilterPage/MapPage.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 64034535
// nb64034535medine
//

class FilteredRealEstates extends StatefulWidget {
  const FilteredRealEstates({
    Key key,
    this.categoryId,
    this.typeId,
    this.locationId,
    this.area,
    this.price,
    this.realtorID,
    this.specValues,
    this.mainTypeId,
  }) : super(key: key);
  final int mainTypeId;
  final String area;
  final int categoryId;
  final int realtorID;
  final int locationId;
  final String price;
  final List typeId;
  final List specValues;

  @override
  State<FilteredRealEstates> createState() => _FilteredRealEstatesState();
}

class _FilteredRealEstatesState extends State<FilteredRealEstates> {
  final AuthController authController = Get.put(AuthController());
  final FilterController filterController = Get.put(FilterController());
  final RefreshController _refreshController = RefreshController();
  void _onRefresh() {
    filterController.page.value = 0;
    filterController.list.clear();

    filterController.loading.value = 0;
    filterController.fetchRealEstates(
        widget.categoryId, widget.typeId, widget.realtorID, widget.price, widget.area, widget.locationId, authController.userId.value, widget.specValues, widget.mainTypeId);
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    if ((pageNumber / 20) > filterController.page.value + 1) {
      filterController.page.value += 1;
      filterController.fetchRealEstates(
          widget.categoryId, widget.typeId, widget.realtorID, widget.price, widget.area, widget.locationId, authController.userId.value, widget.specValues, widget.mainTypeId);
    }
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    filterController.loading.value = 0;
    filterController.sortColumn.value = "";
    filterController.sortDirection.value = "";
    filterController.sortName.value = "sortDefault";
    filterController.fetchRealEstates(
        widget.categoryId, widget.typeId, widget.realtorID, widget.price, widget.area, widget.locationId, authController.userId.value, widget.specValues, widget.mainTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: RaisedButton(
          onPressed: () {
            Get.to(() => MapPage(parametrsMine: {
                  "category_id": "${widget.categoryId}",
                  "type_id": json.encode(widget.typeId),
                  "owner_id": "${widget.realtorID}",
                  "price": widget.price,
                  "area": widget.area,
                  "location_id": "${widget.locationId}",
                  "spec_values": json.encode(widget.specValues),
                }));
          },
          shape: const RoundedRectangleBorder(borderRadius: borderRadius30),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          color: kPrimaryColor,
          disabledColor: kPrimaryColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.map, color: Colors.white, size: 25),
              ),
              Text(
                "showMapFilter".tr,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: robotoMedium),
              )
            ],
          ),
        ),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "searchHouse".tr,
            style: TextStyle(color: Colors.black, fontSize: 18, fontFamily: robotoRegular),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              color: Colors.black,
              icon: Icon(IconlyLight.arrowLeft)),
          actions: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                color: Colors.black,
                icon: Icon(IconlyLight.filter))
          ],
        ),
        body: SizedBox(
          height: Get.size.height,
          width: Get.size.width,
          child: SmartRefresher(
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius5),
                    onPressed: () {
                      sortBottomSheet();
                    },
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.sort, color: Colors.grey, size: 24),
                        ),
                        Expanded(
                          child: Obx(() {
                            return Text(
                              "${filterController.sortName.value}".tr,
                              style: TextStyle(color: Colors.black, fontFamily: robotoRegular),
                            );
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (filterController.loading.value == 1) {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: filterController.list.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Get.size.width <= 800 ? 1 : 2, mainAxisSpacing: 15, childAspectRatio: 9 / 11),
                          itemBuilder: (BuildContext context, int index) {
                            return RealEstateCard2(
                              id: filterController.list[index]["id"],
                              name: filterController.list[index]["name"] as String,
                              price: filterController.list[index]["price"] as String,
                              ownerId: filterController.list[index]["owner_id"],
                              vip: filterController.list[index]["vip"] == 1 ? true : false,
                              location: filterController.list[index]["location"],
                              phone: filterController.list[index]["phone"],
                              addedRealEstate_Text: "",
                              addedRealEstate_Widget: false,
                              images: filterController.list[index]["images"] as List,
                              likedValue: filterController.list[index]["wishList"] == null
                                  ? false
                                  : filterController.list[index]["wishList"] == 0
                                      ? false
                                      : true,
                            );
                          });
                    } else if (filterController.loading.value == 2) {
                      return Center(
                        child: EmptyPage(
                          image: "assets/icons/svgIcons/EmptyPageIcon.svg",
                          text: "emptyRealEstates",
                          subtitle: "",
                          buttonText: "",
                          onTap: () {},
                        ),
                      );
                    } else if (filterController.loading.value == 3) {
                      return Center(
                        child: ConnectionError(
                            buttonText: "",
                            onTap: () {
                              filterController.fetchRealEstates(
                                  widget.categoryId, widget.typeId, widget.realtorID, widget.price, widget.area, widget.locationId, authController.userId.value, widget.specValues, widget.mainTypeId);
                            }),
                      );
                    }
                    return SizedBox(
                      width: Get.size.width,
                      height: Get.size.height,
                      child: Center(
                        child: spinKit(),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List sortData = [
    {
      "id": 1,
      "name": "sortDefault",
      "sort_column": "",
      "sort_direction": "",
    },
    {
      "id": 2,
      "name": "sortPriceLowToHigh",
      "sort_column": "price::integer",
      "sort_direction": "ASC",
    },
    {
      "id": 3,
      "name": "sortPriceHighToLow",
      "sort_column": "price::integer",
      "sort_direction": "DESC",
    },
    {
      "id": 4,
      "name": "sortAreaLowToHigh",
      "sort_column": "area",
      "sort_direction": "ASC",
    },
    {
      "id": 5,
      "name": "sortAreaHighToLow",
      "sort_column": "area",
      "sort_direction": "DESC",
    },
    {
      "id": 6,
      "name": "sortCreatedAtHighToLow",
      "sort_column": "created_at::date",
      "sort_direction": "DESC",
    },
    {
      "id": 7,
      "name": "sortCreatedAtLowToHigh",
      "sort_column": "created_at::date",
      "sort_direction": "ASC",
    },
  ];
  int value = 0;

  Future<dynamic> sortBottomSheet() {
    return Get.bottomSheet(Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "sort".tr,
                  textAlign: TextAlign.center,
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
          Divider(
            color: Colors.grey[200],
            height: 1,
            thickness: 2,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (context, index) {
              return RadioListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
                value: index,
                activeColor: kPrimaryColor,
                groupValue: value,
                onChanged: (ind) {
                  setState(() {
                    value = ind;
                  });

                  filterController.sortColumn.value = sortData[index]["sort_column"];
                  filterController.sortDirection.value = sortData[index]["sort_direction"];
                  filterController.sortName.value = sortData[index]["name"];
                  filterController.loading.value = 0;
                  filterController.list.clear();
                  filterController.fetchRealEstates(
                      widget.categoryId, widget.typeId, widget.realtorID, widget.price, widget.area, widget.locationId, authController.userId.value, widget.specValues, widget.mainTypeId);

                  Get.back();
                },
                title: Text("${sortData[index]["name"]}".tr),
              );
            },
            itemCount: sortData.length,
          )),
        ],
      ),
    ));
  }
}
